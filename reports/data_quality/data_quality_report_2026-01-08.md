# Data Quality Report — 2026-01-12

## Dataset Snapshot
- Raw files ingested: orders, order_items, order_payments, customers, products, category_translation
- Raw row counts:
  - orders = 99,441
  - order_items = 112,650
  - order_payments = 103,886
  - customers = 99,441
  - products = 32,951
  - category_translation = 71
- Curated row counts:
  - dim_date = 800
  - dim_customer = 96,096
  - dim_product = 32,951
  - fact_orders = 99,441
  - fact_order_items = 112,650
- Pipeline status: PASS

## Check Results (Summary)
| Check | Table | Rule / Threshold | Result | Notes |
|---|---|---|---|---|
| Schema | raw | required columns present | PASS | |
| PK uniqueness | fact_orders | order_id unique (100%) | PASS | |
| Missing | fact_orders | customer_unique_id not null (100%) | PASS | 0 nulls |
| Revenue validity | fact_orders | delivered payment_total present (100%) | PASS | 1 order patched |
| PK uniqueness | fact_order_items | (order_id, order_item_id) unique (100%) | PASS | |
| Range | fact_order_items | price >= 0 (0 violations) | PASS | |
| Range | fact_order_items | freight_value >= 0 (0 violations) | PASS | |
| Referential integrity | fact_orders → dim_customer | 100% coverage | PASS | 100% |
| Referential integrity | fact_order_items → dim_product | 100% coverage | PASS | 100% |
| Allocation sanity | fact_order_items | SUM(share) 0.999–1.001 (>=99.9%) | PASS | 100% |

## Issues Found + Fixes
- Issue: 1 delivered order missing payment rows in raw payments table
- Fix: patched payment_total using SUM(item price + freight) for that order
- Impact: 1 order updated; no rows removed

## Warnings / Monitoring
- Category EN coverage: 98.11% (threshold >= 95%) — PASS (WARNING)

## Approval
- Analyst: Tan Ho
- Date: 2026-01-12
