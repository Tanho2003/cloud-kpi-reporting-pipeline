\# Cloud KPI Reporting Pipeline (Raw → Curated → Postgres → Power BI)

\#\# Purpose  
Build a production-style KPI reporting pipeline that ingests raw commerce data, validates data quality, curates clean dimensional tables, loads into PostgreSQL, and powers a Power BI executive dashboard.

\#\# Dataset  
Olist Brazilian E-Commerce Public Dataset (snapshot: 2026-01-12)

\#\# Architecture  
Raw CSVs → Data Quality Gate → Curated Star Schema (CSV) → PostgreSQL (schema: bi) → Power BI Dashboard

\#\# KPIs  
See: \`docs/KPI\_Definitions.md\`

\#\# Data Model (Star Schema)  
Facts:  
\- fact\_orders (order-level)  
\- fact\_order\_items (item-level)

Dimensions:  
\- dim\_date  
\- dim\_customer  
\- dim\_product

See: \`docs/Data\_Dictionary.md\`

\#\# Data Quality Checks (Hire-Ready Differentiator)  
\- DQ gate enforces schema, PK uniqueness, missing thresholds, range checks, referential integrity, and allocation sanity.  
\- Sample report: \`reports/data\_quality/data\_quality\_report\_2026-01-12.md\`

\#\# Raw → Curated Row Counts (2026-01-12)  
| Layer | Table | Rows |  
|---|---|---:|  
| Raw | orders | 99,441 |  
| Raw | order\_items | 112,650 |  
| Raw | order\_payments | 103,886 |  
| Curated | dim\_date | 800 |  
| Curated | dim\_customer | 96,096 |  
| Curated | dim\_product | 32,951 |  
| Curated | fact\_orders | 99,441 |  
| Curated | fact\_order\_items | 112,650 |

\#\# Load Validation (Postgres)  
\- Row counts match curated outputs  
\- Join completeness:  
  \- orders → customers: 100%  
  \- items → products: 100%  
\- Delivered orders: 96,478  
\- Delivered revenue (SUM(payment\_total)): 15,422,605.23 BRL

\#\# Power BI Dashboard  
\#\#\# Month  
\!\[Dashboard \- Month\](assets/dashboard\_months.png)

\#\#\# Year  
\!\[Dashboard \- Year\](assets/dashboard\_years.png)

\#\#\# Total  
\!\[Dashboard \- Total\](assets/dashboard\_total.png)

\#\# Data Model  
\!\[Model\](assets/model.png)

\#\# Repro Steps (Local)  
1\ Build curated tables (Python notebook):  
   \- \`notebooks/06\_build\_curated.ipynb\`  
2\ Load curated CSVs into Postgres (psql):  
   \- \`sql/07\_create\_tables.sql\`  
   \- \`sql/07\_load\_csv\_psql.sql\`  
3\ Connect Power BI to Postgres database \`olist\_bi\` and build visuals

\#\# Notes / Known Edge Cases  
\- 1 delivered order missing payment rows; patched payment\_total using SUM(price \+ freight) and logged in DQ report.  
\- Product category EN translation coverage is not 100%; missing values remain null.

