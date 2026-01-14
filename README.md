# Cloud KPI Reporting Pipeline (Raw → Curated → Postgres → Power BI)

## Purpose
Build a production-style KPI reporting pipeline that ingests raw commerce data, validates data quality, curates clean dimensional tables, loads into PostgreSQL, and powers a Power BI executive dashboard.

## Dataset
Olist Brazilian E-Commerce Public Dataset (snapshot: 2026-01-12)

## Architecture
Raw CSVs → Data Quality Gate → Curated Star Schema (CSV) → PostgreSQL (schema: bi) → Power BI Dashboard

## KPIs
See: `docs/KPI_Definitions.md`

## Data Model (Star Schema)
Facts:
- fact_orders (order-level)
- fact_order_items (item-level)

Dimensions:
- dim_date
- dim_customer
- dim_product

See: `docs/Data_Dictionary.md`

## Data Quality Checks (Hire-Ready Differentiator)
- DQ gate enforces schema, PK uniqueness, missing thresholds, range checks, referential integrity, and allocation sanity.
- Sample report: `reports/data_quality/data_quality_report_2026-01-12.md`

## Raw → Curated Row Counts (2026-01-12)
| Layer | Table | Rows |
|---|---|---:|
| Raw | orders | 99,441 |
| Raw | order_items | 112,650 |
| Raw | order_payments | 103,886 |
| Curated | dim_date | 800 |
| Curated | dim_customer | 96,096 |
| Curated | dim_product | 32,951 |
| Curated | fact_orders | 99,441 |
| Curated | fact_order_items | 112,650 |

## Load Validation (Postgres)
- Row counts match curated outputs
- Join completeness:
  - orders → customers: 100%
  - items → products: 100%
- Delivered orders: 96,478
- Delivered revenue (SUM(payment_total)): 15,422,605.23 BRL

## Power BI Dashboard
### Month
![Dashboard - Month](assets/dashboard_months.png)

### Year
![Dashboard - Year](assets/dashboard_years.png)

### Total
![Dashboard - Total](assets/dashboard_total.png)

## Data Model
![Model](assets/model.png)

## Repro Steps (Local)
1) Build curated tables (Python notebook):
   - `notebooks/06_build_curated.ipynb`
2) Load curated CSVs into Postgres (psql):
   - `sql/07_create_tables.sql`
   - `sql/07_load_csv_psql.sql`
3) Connect Power BI to Postgres database `olist_bi` and build visuals

## Notes / Known Edge Cases
- 1 delivered order missing payment rows; patched payment_total using SUM(price + freight) and logged in DQ report.
- Product category EN translation coverage is not 100%; missing values remain null.
