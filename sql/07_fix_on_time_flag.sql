ALTER TABLE bi.fact_orders
  ALTER COLUMN on_time_flag TYPE DOUBLE PRECISION
  USING on_time_flag::double precision;
