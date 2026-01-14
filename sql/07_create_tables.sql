CREATE SCHEMA IF NOT EXISTS bi;

DROP TABLE IF EXISTS bi.fact_order_items;
DROP TABLE IF EXISTS bi.fact_orders;
DROP TABLE IF EXISTS bi.dim_product;
DROP TABLE IF EXISTS bi.dim_customer;
DROP TABLE IF EXISTS bi.dim_date;

CREATE TABLE bi.dim_date (
  date_id INTEGER PRIMARY KEY,
  date DATE NOT NULL,
  year INTEGER NOT NULL,
  quarter INTEGER NOT NULL,
  month_num INTEGER NOT NULL,
  month_name TEXT NOT NULL,
  year_month TEXT NOT NULL,
  week_num INTEGER NOT NULL,
  day_of_week_num INTEGER NOT NULL,
  day_of_week_name TEXT NOT NULL,
  is_weekend INTEGER NOT NULL
);

CREATE TABLE bi.dim_customer (
  customer_unique_id TEXT PRIMARY KEY,
  customer_id TEXT,
  customer_zip_code_prefix INTEGER,
  customer_city TEXT,
  customer_state TEXT
);

CREATE TABLE bi.dim_product (
  product_id TEXT PRIMARY KEY,
  product_category_name TEXT,
  product_category_name_en TEXT,
  product_weight_g DOUBLE PRECISION,
  product_length_cm DOUBLE PRECISION,
  product_height_cm DOUBLE PRECISION,
  product_width_cm DOUBLE PRECISION
);

CREATE TABLE bi.fact_orders (
  order_id TEXT PRIMARY KEY,
  customer_unique_id TEXT NOT NULL,
  order_status TEXT NOT NULL,
  order_purchase_timestamp TIMESTAMP NOT NULL,
  order_approved_at TIMESTAMP NULL,
  order_delivered_carrier_date TIMESTAMP NULL,
  order_delivered_customer_date TIMESTAMP NULL,
  order_estimated_delivery_date TIMESTAMP NULL,
  purchase_date_id INTEGER NOT NULL,
  delivered_date_id INTEGER NULL,
  is_delivered INTEGER NOT NULL,
  is_canceled_or_unavailable INTEGER NOT NULL,
  delivery_days DOUBLE PRECISION NULL,
  on_time_flag INTEGER NULL,
  payment_total DOUBLE PRECISION NULL,
  payment_count INTEGER NULL
);

CREATE TABLE bi.fact_order_items (
  order_id TEXT NOT NULL,
  order_item_id INTEGER NOT NULL,
  product_id TEXT NOT NULL,
  shipping_limit_date TIMESTAMP NOT NULL,
  price DOUBLE PRECISION NOT NULL,
  freight_value DOUBLE PRECISION NOT NULL,
  item_value DOUBLE PRECISION NOT NULL,
  order_item_value_share DOUBLE PRECISION NULL,
  allocated_revenue DOUBLE PRECISION NULL,
  PRIMARY KEY (order_id, order_item_id)
);
