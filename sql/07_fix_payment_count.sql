ALTER TABLE bi.fact_orders
  ALTER COLUMN payment_count TYPE DOUBLE PRECISION
  USING payment_count::double precision;
