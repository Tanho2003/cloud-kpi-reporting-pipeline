\# KPI Definitions (Cloud KPI Reporting Pipeline)



\## Reporting Scope

\- Dataset: Olist Brazilian E-Commerce (snapshot: 2026-01-12)

\- Currency: BRL (source currency; no FX conversion)

\- Timezone: source timestamps as provided (no conversion)

\- Revenue basis: delivered orders only

\- Exclusions: canceled + unavailable (and other in-progress statuses)



---



\## Real-World Decisions (pre-build)



\### Table grains

\- fact\_orders: 1 row = 1 order\_id

\- fact\_order\_items: 1 row = (order\_id, order\_item\_id)



\### Valid revenue statuses

\- Valid (core KPI): order\_status = delivered

\- Excluded: canceled, unavailable, and in-progress statuses



\### KPI date driver

\- Trend KPIs use: order\_purchase\_timestamp (purchase date)

\- Delivery KPIs use: delivered/estimated dates



---



\## Core KPIs



\### Delivered Revenue

\*\*Definition:\*\* Total paid amount for delivered orders.  

\*\*Formula:\*\* SUM(payment\_total) where order\_status = delivered  

\*\*Grain:\*\* order-level (fact\_orders)  

\*\*Edge cases:\*\* 1 delivered order missing payment rows; patched payment\_total using SUM(price + freight).



\### Delivered Orders

\*\*Definition:\*\* Count of delivered orders.  

\*\*Formula:\*\* DISTINCTCOUNT(order\_id) where order\_status = delivered  

\*\*Grain:\*\* order-level (fact\_orders)



\### AOV (Delivered)

\*\*Definition:\*\* Average revenue per delivered order.  

\*\*Formula:\*\* AOV = Delivered Revenue / Delivered Orders  

\*\*Grain:\*\* order-level (fact\_orders)  

\*\*Inclusions:\*\* delivered orders only  

\*\*Exclusions:\*\* canceled/unavailable



\### Customers (Delivered)

\*\*Definition:\*\* Unique customers with ≥1 delivered order in the period.  

\*\*Formula:\*\* DISTINCTCOUNT(customer\_unique\_id) where order\_status = delivered  

\*\*Customer key:\*\* customer\_unique\_id



\### Repeat Customer Rate

\*\*Definition:\*\* % of customers with 2+ delivered orders (within filter context).  

\*\*Formula:\*\* repeat\_customers / customers\_delivered  

\*\*Customer key:\*\* customer\_unique\_id



\### Delivery Time (Days)

\*\*Definition:\*\* order\_delivered\_customer\_date − order\_purchase\_timestamp (days).  

\*\*Metric:\*\* average (optional: median/p90)  

\*\*Exclusions:\*\* missing delivered timestamp  

\*\*Grain:\*\* order-level (fact\_orders)



\### On-Time Delivery Rate

\*\*Definition:\*\* % of delivered orders delivered on or before estimated delivery date.  

\*\*Rule:\*\* on\_time\_flag = 1 if delivered\_customer\_date <= estimated\_delivery\_date else 0  

\*\*Formula:\*\* AVG(on\_time\_flag) for delivered orders where on\_time\_flag is not null  

\*\*Exclusions:\*\* missing delivered or estimated timestamps  

\*\*Grain:\*\* order-level (fact\_orders)



---



\## Product KPIs



\### Allocated Revenue by Category/Product

\*\*Definition:\*\* Allocate order payment\_total to items proportionally by item\_value share.  

\- item\_value = price + freight\_value  

\- order\_item\_value\_share = item\_value / SUM(item\_value) per order  

\- allocated\_revenue = payment\_total \* order\_item\_value\_share  

\*\*Grain:\*\* item-level (fact\_order\_items)



---



\## Notes

\- “All status” charts (like canceled/unavailable trend) are labeled explicitly and should not be mixed with delivered-only KPIs.



