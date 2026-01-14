\# Data Quality Checks — Curated Layer Gate

\#\# Purpose  
These checks run before publishing curated tables (dims \+ facts). If any \*\*FAIL\*\* in the “Blocker” section, the refresh is considered failed and curated outputs should not be published.

\---

\#\# Severity Levels  
\- \*\*BLOCKER:\*\* must pass (pipeline stops)  
\- \*\*WARNING:\*\* log \+ monitor (pipeline continues, but report must note it)

\---

\#\# Checks by Table

\#\# A) Raw file checks (BLOCKER)  
1\. File exists for each required CSV:  
   \- orders, order\_items, order\_payments, customers, products, category\_translation  
2\. File is readable (non-empty)  
3\. Column headers match expected (schema presence)

\---

\#\# B) dim\_customer (BLOCKER)  
1\. Primary key not null: \`customer\_unique\_id\`  
2\. Primary key uniqueness: \`customer\_unique\_id\` unique  
3\. Location fields sanity (WARNING):  
   \- \`customer\_state\` not null rate \>= 99% (or document actual %)

\---

\#\# C) dim\_product (BLOCKER)  
1\. Primary key not null: \`product\_id\`  
2\. Primary key uniqueness: \`product\_id\` unique  
3\. Category translation coverage (WARNING):  
   \- % of products with \`product\_category\_name\_en\` not null \>= 95%

\---

\#\# D) dim\_date (BLOCKER)  
1\. Primary key uniqueness: \`date\_id\` unique  
2\. Date range covers orders purchase dates (BLOCKER)  
   \- min/max date in dim\_date must cover min/max order\_purchase\_timestamp

\---

\#\# E) fact\_orders (BLOCKER)  
1\. Primary key not null \+ unique: \`order\_id\`  
2\. Not-null fields (BLOCKER):  
   \- \`customer\_unique\_id\` not null  
   \- \`order\_purchase\_timestamp\` not null  
   \- \`order\_status\` not null  
3\. Status domain check (WARNING):  
   \- order\_status values only in allowed set:  
     created, approved, processing, invoiced, shipped, delivered, canceled, unavailable  
4\. Future dates (BLOCKER):  
   \- order\_purchase\_timestamp must not be in the future (relative to run date)  
5\. Payment totals (BLOCKER):  
   \- delivered orders must have payment\_total \> 0  
6\. Delivery logic (WARNING):  
   \- delivery\_days \>= 0 (for delivered orders)  
   \- on\_time\_flag only evaluated when delivered\_date and estimated\_date exist

\---

\#\# F) fact\_order\_items (BLOCKER)  
1\. Primary key uniqueness: (order\_id, order\_item\_id) unique  
2\. Not-null fields (BLOCKER):  
   \- order\_id not null  
   \- order\_item\_id not null  
   \- product\_id not null  
3\. Range checks (BLOCKER):  
   \- price \>= 0  
   \- freight\_value \>= 0  
4\. Share allocation sanity (WARNING):  
   \- For each order\_id, SUM(order\_item\_value\_share) ≈ 1.00 (allow tiny rounding tolerance)

\---

\#\# Referential Integrity (BLOCKER)  
1\. fact\_orders.customer\_unique\_id exists in dim\_customer  
2\. fact\_order\_items.order\_id exists in fact\_orders  
3\. fact\_order\_items.product\_id exists in dim\_product

\---

\#\# Output  
\- A pass/fail report per run saved to:  
  \- Local: \`reports/data\_quality/data\_quality\_report\_YYYY-MM-DD.md\`  
  \- S3 (later): \`reports/data\_quality/data\_quality\_report\_YYYY-MM-DD.md\`

