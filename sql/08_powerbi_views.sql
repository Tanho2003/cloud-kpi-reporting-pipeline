CREATE SCHEMA IF NOT EXISTS pbi;

DROP VIEW IF EXISTS pbi.fact_orders;
CREATE VIEW pbi.fact_orders AS
SELECT
  order_id,
  customer_unique_id,
  order_status,
  order_purchase_timestamp,
  order_approved_at,
  order_delivered_carrier_date,
  order_delivered_customer_date,
  order_estimated_delivery_date,
  purchase_date_id,
  delivered_date_id,
  is_delivered,
  is_canceled_or_unavailable,
  delivery_days,
  CASE
    WHEN on_time_flag IS NULL THEN NULL
    ELSE on_time_flag::int
  END AS on_time_flag,
  payment_total,
  CASE
    WHEN payment_count IS NULL THEN NULL
    ELSE payment_count::int
  END AS payment_count
FROM bi.fact_orders;

DROP VIEW IF EXISTS pbi.fact_order_items;
CREATE VIEW pbi.fact_order_items AS
SELECT * FROM bi.fact_order_items;

DROP VIEW IF EXISTS pbi.dim_date;
CREATE VIEW pbi.dim_date AS SELECT * FROM bi.dim_date;

DROP VIEW IF EXISTS pbi.dim_customer;
CREATE VIEW pbi.dim_customer AS SELECT * FROM bi.dim_customer;

DROP VIEW IF EXISTS pbi.dim_product;
CREATE VIEW pbi.dim_product AS SELECT * FROM bi.dim_product;
