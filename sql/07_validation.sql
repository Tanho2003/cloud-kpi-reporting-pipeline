-- Row counts
SELECT 'dim_date' AS table, COUNT(*) FROM bi.dim_date
UNION ALL SELECT 'dim_customer', COUNT(*) FROM bi.dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM bi.dim_product
UNION ALL SELECT 'fact_orders', COUNT(*) FROM bi.fact_orders
UNION ALL SELECT 'fact_order_items', COUNT(*) FROM bi.fact_order_items;

-- Join completeness
SELECT
  1.0 * SUM(CASE WHEN c.customer_unique_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) AS pct_orders_with_customer
FROM bi.fact_orders o
LEFT JOIN bi.dim_customer c
ON o.customer_unique_id = c.customer_unique_id;

SELECT
  1.0 * SUM(CASE WHEN p.product_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) AS pct_items_with_product
FROM bi.fact_order_items i
LEFT JOIN bi.dim_product p
ON i.product_id = p.product_id;

-- Revenue sanity (delivered)
SELECT
  COUNT(*) AS delivered_orders,
  SUM(payment_total) AS delivered_revenue
FROM bi.fact_orders
WHERE order_status = 'delivered';
