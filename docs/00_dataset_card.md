\# Dataset Card — Olist Brazilian E-Commerce (Snapshot: 2026-01-12)

\## Source  
Olist Brazilian E-Commerce Public Dataset (CSV archive)

\## Snapshot location  
- Local: data/raw/olist/2026-01-01/  
- S3 (later): s3://<bucket>/raw/olist/2026-01-12/

\## Time range (orders)  
- 2016-09-04 to 2018-10-17

\## Core tables (used in pipeline)  
- olist\_orders\_dataset.csv (~99,441 rows)  
- olist\_order\_items\_dataset.csv (~112,650 rows)  
- olist\_order\_payments\_dataset.csv (~103,886 rows)  
- olist\_customers\_dataset.csv (~99,441 rows)  
- olist\_products\_dataset.csv (~32,951 rows)  
- product\_category\_name\_translation.csv (71 rows)

\## Optional tables (phase 2)  
- olist\_order\_reviews\_dataset.csv (~99,224 rows)  
- olist\_sellers\_dataset.csv (~3,095 rows)  
- olist\_geolocation\_dataset.csv (~1,000,163 rows)

\## Primary join keys  
- orders.order\_id → order\_items.order\_id, payments.order\_id, reviews.order\_id  
- orders.customer\_id → customers.customer\_id  
- order\_items.product\_id → products.product\_id  
- products.product\_category\_name → translation.product\_category\_name

\## Planned fact grains  
- Fact (order-level): 1 row per order\_id  
- Fact (item-level): 1 row per (order\_id, order\_item\_id)

\## Notes / assumptions  
- Revenue will be based on payments (unless stated otherwise)  
- Canceled/unavailable orders excluded from “completed” KPIs

