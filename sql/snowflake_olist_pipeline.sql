/* ============================================================
   1. Warehouse, database, and schemas
   ============================================================ */

CREATE WAREHOUSE IF NOT EXISTS WH_XS
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND   = 60
  AUTO_RESUME    = TRUE;

CREATE DATABASE IF NOT EXISTS OLIST_BI;

CREATE SCHEMA IF NOT EXISTS OLIST_BI.RAW;   -- raw landing tables
CREATE SCHEMA IF NOT EXISTS OLIST_BI.BI;    -- curated facts/dims
CREATE SCHEMA IF NOT EXISTS OLIST_BI.PBI;   -- BI / Power BI views

USE WAREHOUSE WH_XS;
USE DATABASE  OLIST_BI;


/* ============================================================
   2. S3 integration, file format, and stage
   ============================================================ */

-- Storage integration (assumes IAM role & trust policy already set up in AWS)
CREATE OR REPLACE STORAGE INTEGRATION OLIST_S3_INT
  TYPE                    = EXTERNAL_STAGE
  STORAGE_PROVIDER        = S3
  ENABLED                 = TRUE
  STORAGE_AWS_ROLE_ARN    = 'arn:aws:iam::XXX:role/snowflake_olist_s3_role'
  STORAGE_ALLOWED_LOCATIONS = (
    's3://cloud-kpi-tanho2003-olist/raw/olist/',
    's3://cloud-kpi-tanho2003-olist/curated/olist/',
    's3://cloud-kpi-tanho2003-olist/reports/data_quality/'
  );

-- inspect integration
DESC INTEGRATION OLIST_S3_INT;

-- Work in RAW schema
USE SCHEMA RAW;

-- CSV file format for all Olist CSVs
CREATE OR REPLACE FILE FORMAT OLIST_CSV_FF
  TYPE                      = CSV
  SKIP_HEADER               = 1
  FIELD_DELIMITER           = ','
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF                   = ('', 'NULL', 'null')
  EMPTY_FIELD_AS_NULL       = TRUE;

-- Stage pointing to the raw folder for a given load date
CREATE OR REPLACE STAGE OLIST_RAW_STAGE
  STORAGE_INTEGRATION = OLIST_S3_INT
  URL                 = 's3://cloud-kpi-tanho2003-olist/raw/olist/2026-01-12/'
  FILE_FORMAT         = OLIST_CSV_FF;

-- Sanity check: list files in the stage
LIST @OLIST_RAW_STAGE;


/* ============================================================
   3. RAW tables – load all core Olist datasets
   ============================================================ */

-- Orders
CREATE OR REPLACE TABLE OLIST_ORDERS USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION     => '@OLIST_RAW_STAGE/olist_orders_dataset.csv',
      FILE_FORMAT  => 'OLIST_CSV_FF'
    )
  )
);

COPY INTO OLIST_ORDERS
FROM @OLIST_RAW_STAGE/olist_orders_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'OLIST_CSV_FF')
ON_ERROR    = 'ABORT_STATEMENT';


-- Customers
CREATE OR REPLACE TABLE OLIST_CUSTOMERS USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION     => '@OLIST_RAW_STAGE/olist_customers_dataset.csv',
      FILE_FORMAT  => 'OLIST_CSV_FF'
    )
  )
);

COPY INTO OLIST_CUSTOMERS
FROM @OLIST_RAW_STAGE/olist_customers_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'OLIST_CSV_FF')
ON_ERROR    = 'ABORT_STATEMENT';


-- Order items
CREATE OR REPLACE TABLE OLIST_ORDER_ITEMS USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION     => '@OLIST_RAW_STAGE/olist_order_items_dataset.csv',
      FILE_FORMAT  => 'OLIST_CSV_FF'
    )
  )
);

COPY INTO OLIST_ORDER_ITEMS
FROM @OLIST_RAW_STAGE/olist_order_items_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'OLIST_CSV_FF')
ON_ERROR    = 'ABORT_STATEMENT';


-- Order payments
CREATE OR REPLACE TABLE OLIST_ORDER_PAYMENTS USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION     => '@OLIST_RAW_STAGE/olist_order_payments_dataset.csv',
      FILE_FORMAT  => 'OLIST_CSV_FF'
    )
  )
);

COPY INTO OLIST_ORDER_PAYMENTS
FROM @OLIST_RAW_STAGE/olist_order_payments_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'OLIST_CSV_FF')
ON_ERROR    = 'ABORT_STATEMENT';


-- Products
CREATE OR REPLACE TABLE OLIST_PRODUCTS USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION     => '@OLIST_RAW_STAGE/olist_products_dataset.csv',
      FILE_FORMAT  => 'OLIST_CSV_FF'
    )
  )
);

COPY INTO OLIST_PRODUCTS
FROM @OLIST_RAW_STAGE/olist_products_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'OLIST_CSV_FF')
ON_ERROR    = 'ABORT_STATEMENT';


-- Category translation
CREATE OR REPLACE TABLE PRODUCT_CATEGORY_NAME_TRANSLATION USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION     => '@OLIST_RAW_STAGE/product_category_name_translation.csv',
      FILE_FORMAT  => 'OLIST_CSV_FF'
    )
  )
);

COPY INTO PRODUCT_CATEGORY_NAME_TRANSLATION
FROM @OLIST_RAW_STAGE/product_category_name_translation.csv
FILE_FORMAT = (FORMAT_NAME = 'OLIST_CSV_FF')
ON_ERROR    = 'ABORT_STATEMENT';


/* Optional quick checks */
SELECT 'ORDERS'    AS table_name, COUNT(*) AS row_count FROM OLIST_ORDERS
UNION ALL
SELECT 'CUSTOMERS' AS table_name, COUNT(*) AS row_count FROM OLIST_CUSTOMERS
UNION ALL
SELECT 'ITEMS'     AS table_name, COUNT(*) AS row_count FROM OLIST_ORDER_ITEMS
UNION ALL
SELECT 'PAYMENTS'  AS table_name, COUNT(*) AS row_count FROM OLIST_ORDER_PAYMENTS
UNION ALL
SELECT 'PRODUCTS'  AS table_name, COUNT(*) AS row_count FROM OLIST_PRODUCTS
UNION ALL
SELECT 'TRANS'     AS table_name, COUNT(*) AS row_count FROM PRODUCT_CATEGORY_NAME_TRANSLATION;


/* ============================================================
   4. BI schema – dimensions and fact tables
   ============================================================ */

USE SCHEMA BI;

-- DIM_CUSTOMER
CREATE OR REPLACE TABLE DIM_CUSTOMER AS
SELECT
  "c1" AS customer_id,
  "c2" AS customer_unique_id,
  "c3" AS customer_zip_code_prefix,
  "c4" AS customer_city,
  "c5" AS customer_state
FROM OLIST_BI.RAW.OLIST_CUSTOMERS;


-- DIM_PRODUCT (join to translation for English names)
CREATE OR REPLACE TABLE DIM_PRODUCT AS
SELECT
  p."c1" AS product_id,
  p."c2" AS product_category_name,
  t."c2" AS product_category_name_english,
  p."c3" AS product_name_length,
  p."c4" AS product_description_length,
  p."c5" AS product_photos_qty,
  p."c6" AS product_weight_g,
  p."c7" AS product_length_cm,
  p."c8" AS product_height_cm,
  p."c9" AS product_width_cm
FROM OLIST_BI.RAW.OLIST_PRODUCTS p
LEFT JOIN OLIST_BI.RAW.PRODUCT_CATEGORY_NAME_TRANSLATION t
    ON p."c2" = t."c1";


-- FACT_ORDERS (join aggregated payments)
CREATE OR REPLACE TABLE FACT_ORDERS AS
SELECT
    o."c1" AS order_id,
    o."c2" AS customer_id,
    o."c3" AS order_status,
    o."c4" AS order_purchase_timestamp,
    o."c5" AS order_approved_at,
    o."c6" AS order_delivered_carrier_date,
    o."c7" AS order_delivered_customer_date,
    o."c8" AS order_estimated_delivery_date,
    p.total_payment_value,
    p.total_installments,
    p.payment_type_any
FROM OLIST_BI.RAW.OLIST_ORDERS o
LEFT JOIN (
    SELECT
        "c1"                AS order_id,
        SUM("c5")           AS total_payment_value,
        SUM("c4")           AS total_installments,
        MAX("c3")           AS payment_type_any
    FROM OLIST_BI.RAW.OLIST_ORDER_PAYMENTS
    GROUP BY 1
) p
ON o."c1" = p.order_id;


-- FACT_ORDER_ITEMS
CREATE OR REPLACE TABLE FACT_ORDER_ITEMS AS
SELECT
  "c1" AS order_id,
  "c2" AS order_item_id,
  "c3" AS product_id,
  "c4" AS seller_id,
  "c5" AS shipping_limit_date,
  "c6" AS price,
  "c7" AS freight_value
FROM OLIST_BI.RAW.OLIST_ORDER_ITEMS;


/* ============================================================
   5. DIM_DATE
   ============================================================ */

CREATE OR REPLACE TABLE DIM_DATE AS
WITH base AS (
  SELECT
    DATEADD('day', SEQ4(), '2016-01-01') AS date_key
  FROM TABLE(GENERATOR(ROWCOUNT => 1000))
)
SELECT
  date_key,
  YEAR(date_key)               AS year,
  MONTH(date_key)              AS month,
  DAY(date_key)                AS day,
  TO_CHAR(date_key, 'YYYY-MM') AS year_month,
  TO_CHAR(date_key, 'MON')     AS month_short,
  DAYOFWEEK(date_key)          AS weekday_num,
  TO_CHAR(date_key, 'DY')      AS weekday_short
FROM base;


/* ============================================================
   6. PBI schema – views for BI / Power BI
   ============================================================ */

USE SCHEMA PBI;

-- Date dimension view
CREATE OR REPLACE VIEW V_DIM_DATE AS
SELECT *
FROM OLIST_BI.BI.DIM_DATE;

-- Customer dimension view
CREATE OR REPLACE VIEW V_DIM_CUSTOMER AS
SELECT *
FROM OLIST_BI.BI.DIM_CUSTOMER;

-- Product dimension view
CREATE OR REPLACE VIEW V_DIM_PRODUCT AS
SELECT *
FROM OLIST_BI.BI.DIM_PRODUCT;

-- Orders fact view (with on_time_flag)
CREATE OR REPLACE VIEW V_FACT_ORDERS AS
SELECT
  order_id,
  customer_id,
  order_status,
  order_purchase_timestamp,
  order_approved_at,
  order_delivered_carrier_date,
  order_delivered_customer_date,
  order_estimated_delivery_date,
  total_payment_value,
  total_installments,
  payment_type_any,
  IFF(
    order_status = 'delivered'
    AND order_delivered_customer_date <= order_estimated_delivery_date,
    1, 0
  ) AS on_time_flag
FROM OLIST_BI.BI.FACT_ORDERS;

-- Order items fact view
CREATE OR REPLACE VIEW V_FACT_ORDER_ITEMS AS
SELECT *
FROM OLIST_BI.BI.FACT_ORDER_ITEMS;

-- Final sanity check
SELECT COUNT(*) AS row_count FROM V_FACT_ORDERS;
