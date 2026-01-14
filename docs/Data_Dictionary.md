\# Data Dictionary (Curated Layer)

\#\# Curated Tables (Snapshot: 2026-01-12)  
\- dim\_date (800 rows)  
\- dim\_customer (96,096 rows)  
\- dim\_product (32,951 rows)  
\- fact\_orders (99,441 rows)  
\- fact\_order\_items (112,650 rows)

\---

\#\# dim\_date  
| Column | Type | Description | Notes |  
|---|---|---|---|  
| date\_id | int | Surrogate key YYYYMMDD | PK |  
| date | date | Calendar date | |  
| year | int | Year | |  
| quarter | int | Quarter (1–4) | |  
| month\_num | int | Month (1–12) | |  
| month\_name | text | Month name | |  
| year\_month | text | YYYY-MM | used for trends |  
| week\_num | int | ISO week number | |  
| day\_of\_week\_num | int | Mon=1 … Sun=7 | |  
| day\_of\_week\_name | text | Day name | |  
| is\_weekend | int | 1 weekend, 0 otherwise | |

\---

\#\# dim\_customer  
| Column | Type | Description | Notes |  
|---|---|---|---|  
| customer\_unique\_id | text | Unique customer identifier | PK (customer behavior key) |  
| customer\_id | text | Customer id used on orders | attribute; can vary per unique customer |  
| customer\_zip\_code\_prefix | int | Zip prefix | |  
| customer\_city | text | City | |  
| customer\_state | text | State | |

Rule: 1 row per \`customer\_unique\_id\`, keeping the record from the latest purchase timestamp.

\---

\#\# dim\_product  
| Column | Type | Description | Notes |  
|---|---|---|---|  
| product\_id | text | Unique product identifier | PK |  
| product\_category\_name | text | Category (PT) | nullable |  
| product\_category\_name\_en | text | Category (EN) | joined via translation (98.11% coverage) |  
| product\_weight\_g | numeric | Product weight | |  
| product\_length\_cm | numeric | Length | |  
| product\_height\_cm | numeric | Height | |  
| product\_width\_cm | numeric | Width | |

\---

\#\# fact\_orders  
| Column | Type | Description | Notes |  
|---|---|---|---|  
| order\_id | text | Unique order id | PK |  
| customer\_unique\_id | text | Customer behavior key | FK → dim\_customer |  
| order\_status | text | Order status | delivered used for core KPIs |  
| order\_purchase\_timestamp | timestamp | Purchase time | KPI date driver |  
| order\_approved\_at | timestamp | Approved time | nullable |  
| order\_delivered\_carrier\_date | timestamp | Carrier delivered date | nullable |  
| order\_delivered\_customer\_date | timestamp | Customer delivered date | nullable |  
| order\_estimated\_delivery\_date | timestamp | Estimated delivery | nullable |  
| purchase\_date\_id | int | YYYYMMDD from purchase timestamp | FK → dim\_date |  
| delivered\_date\_id | int | YYYYMMDD from delivered customer date | nullable |  
| is\_delivered | int | 1 if status=delivered | |  
| is\_canceled\_or\_unavailable | int | 1 if canceled/unavailable | |  
| delivery\_days | numeric | Delivered \- purchase (days) | nullable |  
| on\_time\_flag | numeric | 1 on-time, 0 late | nullable |  
| payment\_total | numeric | SUM(payment\_value) per order | revenue basis |  
| payment\_count | numeric | number of payment rows | patched order uses 0 |

Grain: 1 row per order.

\---

\#\# fact\_order\_items  
| Column | Type | Description | Notes |  
|---|---|---|---|  
| order\_id | text | Order id | FK → fact\_orders |  
| order\_item\_id | int | Item sequence within order | PK (with order\_id) |  
| product\_id | text | Product id | FK → dim\_product |  
| shipping\_limit\_date | timestamp | Shipping deadline | |  
| price | numeric | Item price | \>=0 |  
| freight\_value | numeric | Freight cost | \>=0 |  
| item\_value | numeric | price \+ freight\_value | |  
| order\_item\_value\_share | numeric | item\_value / sum(item\_value) per order | sums \~1 |  
| allocated\_revenue | numeric | payment\_total \* value\_share | ties products to payment revenue |

Grain: 1 row per (order\_id, order\_item\_id).

