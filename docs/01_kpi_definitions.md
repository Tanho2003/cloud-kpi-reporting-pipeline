\# KPI Definitions — Cloud KPI Reporting Pipeline (Olist)

\#\# Reporting rules (single source of truth)

\#\#\# Order population used for “core KPIs”  
\- Core KPIs (Revenue, Orders, AOV, Repeat Rate, Cohorts) use \*\*delivered orders only\*\*  
\- Excluded statuses: \*\*canceled\*\*, \*\*unavailable\*\*  
\- Other statuses in dataset (for reference): created, approved, processing, invoiced, shipped, delivered

\#\#\# Revenue definition  
\- \*\*Revenue \= SUM(payment\_value)\*\* from \`olist\_order\_payments\_dataset.csv\`  
\- Grain: \*\*order\_id\*\* (sum all payment rows per order\_id)

\#\#\# Date definition for trends \+ cohorts  
\- Trend date: \`order\_purchase\_timestamp\`  
\- Customer first purchase date: MIN(\`order\_purchase\_timestamp\`) per \`customer\_unique\_id\`  
\- Delivery KPIs use delivered timestamps (see Delivery section)

\---

\#\# KPI List (definitions)

\#\# North Star  
\#\#\# Revenue  
\- Definition: Total paid amount for delivered orders.  
\- Formula: SUM(payment\_value) where order\_status \= 'delivered'  
\- Source: payments.payment\_value \+ orders.order\_status

\---

\#\# Sales KPIs  
\#\#\# Orders  
\- Definition: Count of delivered orders.  
\- Formula: COUNT(DISTINCT order\_id) where order\_status \= 'delivered'  
\- Source: orders.order\_id, orders.order\_status

\#\#\# Average Order Value (AOV)  
\- Definition: Average revenue per delivered order.  
\- Formula: Revenue / Orders  
\- Notes: Delivered orders only.

\#\#\# Monthly Revenue \+ MoM %  
\- Definition: Revenue grouped by purchase month and month-over-month change.  
\- Formula:  
  \- Monthly Revenue \= Revenue by MONTH(order\_purchase\_timestamp)  
  \- MoM % \= (this\_month \- last\_month) / last\_month  
\- Source: orders.order\_purchase\_timestamp \+ payments.payment\_value

\---

\#\# Customer KPIs  
\#\#\# New Customers  
\- Definition: Customers whose first purchase month equals the selected month.  
\- Formula: COUNT(DISTINCT customer\_unique\_id) where first\_purchase\_month \= month  
\- Source: customers.customer\_unique\_id \+ orders.order\_purchase\_timestamp

\#\#\# Returning Customers  
\- Definition: Customers who purchased in the month and had a first purchase before that month.  
\- Formula: COUNT(DISTINCT customer\_unique\_id) where purchase\_month \= month AND first\_purchase\_month \< month

\#\#\# Repeat Customer Rate  
\- Definition: Share of customers with 2+ delivered orders.  
\- Formula: (\# customers with delivered\_orders \>= 2\) / (\# customers with delivered\_orders \>= 1\)  
\- Source: orders.order\_id \+ customers.customer\_unique\_id

\#\#\# Cohort Retention (Monthly)  
\- Definition: For each cohort (first purchase month), the % of customers who purchase again in month 1, 2, 3…  
\- Logic:  
  \- Cohort month \= first\_purchase\_month  
  \- Activity month \= purchase\_month  
  \- Retention % \= active\_customers\_in\_month\_n / cohort\_size  
\- Output: cohort heatmap and/or retention curve

\---

\#\# Product KPIs  
\#\#\# Revenue by Category (allocated)  
\- Definition: Revenue allocated to product categories using each item’s value share within the order.  
\- Allocation approach:  
  \- item\_value \= price \+ freight\_value  
  \- order\_item\_share \= item\_value / SUM(item\_value) over order\_id  
  \- allocated\_revenue \= order\_payment\_total \* order\_item\_share  
\- Source: order\_items.price, order\_items.freight\_value, products.product\_category\_name (+ translation)

\#\#\# Top Products / Top Categories  
\- Definition: Rank products/categories by allocated revenue (or by quantity) for delivered orders.  
\- Formula:  
  \- Revenue rank: SUM(allocated\_revenue) by product/category  
  \- Quantity rank: COUNT(\*) (item rows) by product/category

\---

\#\# Delivery / Ops KPIs  
\#\#\# Avg Delivery Time (days)  
\- Definition: Average days from purchase to delivered-to-customer.  
\- Formula: AVG(order\_delivered\_customer\_date \- order\_purchase\_timestamp) for delivered orders  
\- Source: orders.order\_purchase\_timestamp, orders.order\_delivered\_customer\_date

\#\#\# On-Time Delivery Rate  
\- Definition: % delivered on/before estimated delivery date.  
\- Formula: COUNT(delivered\_date \<= estimated\_date) / COUNT(delivered)  
\- Source: orders.order\_delivered\_customer\_date, orders.order\_estimated\_delivery\_date

\---

\#\# Global dashboard filters  
\- Date filter uses: order\_purchase\_timestamp  
\- Geography (optional): customer\_state / customer\_city  
\- Category filter uses: translated category name (EN)

\---

\#\# Assumptions / Notes  
\- Core KPIs exclude canceled/unavailable to avoid inflated revenue/orders.  
\- If “in-progress” orders are included later, label clearly (e.g., “Booked Revenue” vs “Delivered Revenue”).

