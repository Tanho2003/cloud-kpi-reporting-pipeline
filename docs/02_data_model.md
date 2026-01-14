\# Data Model — Star Schema (Olist)

\#\# Goal  
Create a clean star schema that supports consistent KPI reporting in Power BI:  
\- Order-level KPIs (Revenue, Orders, AOV, Delivery)  
\- Item/product KPIs (Category/Product performance)  
\- Customer KPIs (Repeat rate, cohorts)

\---

\#\# Grains (non-negotiable)  
\- \*\*fact\_orders\*\* \= 1 row per \`order\_id\`  
\- \*\*fact\_order\_items\*\* \= 1 row per (\`order\_id\`, \`order\_item\_id\`)

\---

\#\# Dimensions

\#\# dim\_date  
\*\*Grain:\*\* 1 row per calendar date    
\*\*Primary key:\*\* \`date\_id\` (YYYYMMDD as integer)

\*\*Columns\*\*  
\- date\_id  
\- date (YYYY-MM-DD)  
\- year  
\- quarter  
\- month\_num  
\- month\_name  
\- year\_month (YYYY-MM)  
\- week\_num  
\- day\_of\_week\_num  
\- day\_of\_week\_name  
\- is\_weekend

\*\*Used for\*\*  
\- Trends (monthly revenue/orders)  
\- Cohorts (first purchase month)

\---

\#\# dim\_customer  
\*\*Grain:\*\* 1 row per \`customer\_unique\_id\`    
\*\*Primary key:\*\* \`customer\_unique\_id\`

\*\*Columns\*\*  
\- customer\_unique\_id  
\- customer\_id (latest seen; keep as attribute)  
\- customer\_zip\_code\_prefix  
\- customer\_city  
\- customer\_state

\*\*Notes\*\*  
\- Use \`customer\_unique\_id\` for customer behavior (repeat/cohorts)  
\- \`customer\_id\` can change for the same unique customer across orders

\---

\#\# dim\_product  
\*\*Grain:\*\* 1 row per \`product\_id\`    
\*\*Primary key:\*\* \`product\_id\`

\*\*Columns\*\*  
\- product\_id  
\- product\_category\_name (PT)  
\- product\_category\_name\_en (from translation table)  
\- product\_weight\_g  
\- product\_length\_cm  
\- product\_height\_cm  
\- product\_width\_cm

\---

\#\# Facts

\#\# fact\_orders  
\*\*Grain:\*\* 1 row per \`order\_id\`    
\*\*Primary key:\*\* \`order\_id\`

\*\*Foreign keys\*\*  
\- customer\_unique\_id → dim\_customer.customer\_unique\_id  
\- purchase\_date\_id → dim\_date.date\_id (from order\_purchase\_timestamp)  
\- delivered\_date\_id → dim\_date.date\_id (from order\_delivered\_customer\_date; nullable)

\*\*Columns (base)\*\*  
\- order\_id  
\- customer\_unique\_id  
\- order\_status  
\- order\_purchase\_timestamp  
\- order\_approved\_at (nullable)  
\- order\_delivered\_carrier\_date (nullable)  
\- order\_delivered\_customer\_date (nullable)  
\- order\_estimated\_delivery\_date (nullable)

\*\*Columns (derived / reporting-friendly)\*\*  
\- purchase\_date\_id  
\- delivered\_date\_id  
\- is\_delivered (1/0)  
\- is\_canceled\_or\_unavailable (1/0)  
\- delivery\_days (delivered\_customer\_date \- purchase\_timestamp, in days; nullable)  
\- on\_time\_flag (delivered\_customer\_date \<= estimated\_delivery\_date; nullable)

\*\*Revenue columns (from payments)\*\*  
\- payment\_total (SUM(payment\_value) per order\_id)  
\- payment\_count (number of payment rows per order\_id)

\---

\#\# fact\_order\_items  
\*\*Grain:\*\* 1 row per (\`order\_id\`, \`order\_item\_id\`)    
\*\*Primary key:\*\* (\`order\_id\`, \`order\_item\_id\`)

\*\*Foreign keys\*\*  
\- order\_id → fact\_orders.order\_id  
\- product\_id → dim\_product.product\_id

\*\*Columns (base)\*\*  
\- order\_id  
\- order\_item\_id  
\- product\_id  
\- seller\_id (optional for phase 2\)  
\- shipping\_limit\_date  
\- price  
\- freight\_value

\*\*Columns (derived)\*\*  
\- item\_value \= price \+ freight\_value  
\- order\_item\_value\_share \= item\_value / SUM(item\_value) over order\_id  
\- allocated\_revenue \= fact\_orders.payment\_total \* order\_item\_value\_share

\*\*Notes\*\*  
\- allocated\_revenue enables “Revenue by category/product” that ties back to payments

\---

\#\# Relationship map (Power BI)  
\- dim\_date\[date\_id\] 1-\* fact\_orders\[purchase\_date\_id\]  
\- dim\_customer\[customer\_unique\_id\] 1-\* fact\_orders\[customer\_unique\_id\]  
\- fact\_orders\[order\_id\] 1-\* fact\_order\_items\[order\_id\]  
\- dim\_product\[product\_id\] 1-\* fact\_order\_items\[product\_id\]

\---

\#\# Reporting rules alignment  
\- “Core KPIs” filter on: fact\_orders.is\_delivered \= 1  
\- Revenue uses: fact\_orders.payment\_total  
\- Product/category revenue uses: fact\_order\_items.allocated\_revenue

\---

\#\# Output tables you will publish (curated layer)  
\- curated/dim\_date/  
\- curated/dim\_customer/  
\- curated/dim\_product/  
\- curated/fact\_orders/  
\- curated/fact\_order\_items/

