\# KPI Definitions (Cloud KPI Reporting Pipeline)

\#\# Reporting Scope (Source of Truth)  
\- Dataset: Olist Brazilian E-Commerce (CSV snapshot: 2026-01-12)  
\- Currency: BRL (source currency; no FX conversion applied)  
\- Timezone: Source timestamps (treated as provided; no timezone conversion applied)  
\- Revenue basis: Paid/Completed orders only (see “Valid Order Rules”)  
\- Exclusions: canceled \+ unavailable orders (not included in core KPI reporting)

\---

\#\# Real-World Decisions (pre-build)  
These decisions prevent KPI disputes and make the dashboard “trustworthy.”

\#\#\# 1\) Table grains (what 1 row represents)  
\- \*\*fact\_orders:\*\* 1 row \= 1 order (\`order\_id\`)  
\- \*\*fact\_order\_items:\*\* 1 row \= 1 product line within an order (\`order\_id\`, \`order\_item\_id\`)

\#\#\# 2\) Valid revenue statuses  
\*\*Valid (core KPI) orders:\*\* \`order\_status \= delivered\`    
\*\*Excluded:\*\* \`canceled\`, \`unavailable\` (and other in-progress statuses)

Reason: \`delivered\` is the cleanest completed definition for this dataset and avoids inflating revenue/orders.

\#\#\# 3\) KPI date driver  
All trend KPIs (Revenue/Orders/AOV/Customers) use:  
\- \*\*KPI Date:\*\* \`order\_purchase\_timestamp\` (purchase date)

Delivery KPIs (delivery time, on-time rate) use delivered timestamps.

\---

\#\# Core KPIs

\#\#\# Revenue (Delivered)  
\*\*Definition:\*\* Total paid amount for delivered orders.    
\*\*Formula:\*\* SUM(\`payment\_total\`) where status \= delivered    
\*\*Grain:\*\* order-level (fact\_orders)    
\*\*Excludes:\*\* canceled/unavailable orders    
\*\*Edge cases:\*\*    
\- 1 delivered order had missing payment rows; \`payment\_total\` was patched using SUM(item \`price\` \+ \`freight\_value\`). Logged in DQ report.

\#\#\# Orders (Delivered)  
\*\*Definition:\*\* Count of delivered orders.    
\*\*Formula:\*\* DISTINCTCOUNT(\`order\_id\`) where status \= delivered    
\*\*Grain:\*\* order-level (fact\_orders)

\#\#\# AOV (Delivered)  
\*\*Definition:\*\* Average revenue per delivered order.    
\*\*Formula:\*\* Revenue / Orders    
\*\*Grain:\*\* order-level

\#\#\# Customers (Delivered)  
\*\*Definition:\*\* Unique customers who placed ≥1 delivered order in the period.    
\*\*Formula:\*\* DISTINCTCOUNT(\`customer\_unique\_id\`) where status \= delivered    
\*\*Customer key:\*\* \`customer\_unique\_id\` (dim\_customer)

\#\#\# Repeat Customer Rate  
\*\*Definition:\*\* % of customers with 2+ delivered orders (lifetime or within filter context).    
\*\*Formula:\*\* repeat\_customers / customers    
\*\*Customer key:\*\* \`customer\_unique\_id\`

\#\#\# Monthly Retention (Cohorts)  
\*\*Definition:\*\* For each cohort (first purchase month), % active in month N.    
\*\*Cohort rule:\*\* cohort\_month \= MIN(purchase month) per customer    
\*\*Active rule:\*\* customer has ≥1 delivered order in that month    
\*\*Output:\*\* cohort heatmap or retention curve

\#\#\# Cancel / Unavailable Rate (Optional)  
\*\*Definition:\*\* canceled\_or\_unavailable\_orders / total\_orders    
\*\*Note:\*\* This KPI is informational only; core KPIs exclude these statuses.

\#\#\# Delivery Time (Days)  
\*\*Definition:\*\* delivered\_customer\_date − purchase\_timestamp    
\*\*Metric:\*\* median \+ p90 recommended (avg also OK)    
\*\*Exclusions:\*\* orders missing delivered timestamp    
\*\*Grain:\*\* order-level

\#\#\# On-Time Delivery Rate  
\*\*Definition:\*\* % delivered on or before estimated delivery date    
\*\*Rule:\*\* delivered\_customer\_date \<= estimated\_delivery\_date    
\*\*Exclusions:\*\* missing delivered or estimated timestamps    
\*\*Grain:\*\* order-level

