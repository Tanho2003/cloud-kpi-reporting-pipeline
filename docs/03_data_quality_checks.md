\# Data Quality Checks — Curated Layer Gate



\## Purpose

Checks run before publishing curated tables (dims + facts). If any \*\*BLOCKER\*\* fails, the refresh is considered failed and curated outputs should not be published.



---



\## Severity Levels

\- \*\*BLOCKER:\*\* must pass (pipeline stops)

\- \*\*WARNING:\*\* log + monitor (pipeline continues, but report must note it)



---



\## Pass/Fail Thresholds (Gate Rules)



\### BLOCKER (must pass)

\- PK uniqueness: \*\*100%\*\*

\- PK not null: \*\*100%\*\*

\- Referential integrity (FK coverage): \*\*100%\*\*

\- Delivered orders payment\_total present: \*\*100%\*\*

\- Numeric ranges: price >= 0, freight\_value >= 0 (\*\*0 violations\*\*)



\### WARNING (monitor)

\- Category EN coverage >= \*\*95%\*\*

\- Allocation sanity: per-order SUM(order\_item\_value\_share) between \*\*0.999 and 1.001\*\* for >= \*\*99.9%\*\* of orders



---



\## Checks by Table



\### Raw file checks (BLOCKER)

\- Required files exist and are readable

\- Schema/required columns present



\### dim\_customer (BLOCKER)

\- customer\_unique\_id not null and unique



\### dim\_product (BLOCKER)

\- product\_id not null and unique



\### dim\_date (BLOCKER)

\- date\_id not null and unique

\- covers purchase dates in fact\_orders



\### fact\_orders (BLOCKER)

\- order\_id not null and unique

\- customer\_unique\_id not null

\- order\_purchase\_timestamp not null

\- delivered orders have payment\_total present



\### fact\_order\_items (BLOCKER)

\- (order\_id, order\_item\_id) unique

\- product\_id not null

\- price >= 0, freight\_value >= 0



\### Referential integrity (BLOCKER)

\- fact\_orders.customer\_unique\_id exists in dim\_customer

\- fact\_order\_items.order\_id exists in fact\_orders

\- fact\_order\_items.product\_id exists in dim\_product



\### Allocation sanity (WARNING)

\- SUM(order\_item\_value\_share) ≈ 1 per order (tolerance 0.999–1.001)



