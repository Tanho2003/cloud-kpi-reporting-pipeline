\# Raw → Curated Mapping (Olist)

\#\# Inputs (raw)  
Core raw files:  
\- olist\_orders\_dataset.csv  
\- olist\_order\_items\_dataset.csv  
\- olist\_order\_payments\_dataset.csv  
\- olist\_customers\_dataset.csv  
\- olist\_products\_dataset.csv  
\- product\_category\_name\_translation.csv

\---

\#\# dim\_customer  
\*\*Sources\*\*  
\- customers

\*\*Key fields\*\*  
\- customer\_unique\_id (PK)  
\- customer\_id (attribute)  
\- customer\_zip\_code\_prefix, customer\_city, customer\_state

\*\*Rules\*\*  
\- 1 row per customer\_unique\_id  
\- If multiple customer\_id exist for same customer\_unique\_id, keep the latest seen (document approach)

\---

\#\# dim\_product  
\*\*Sources\*\*  
\- products  
\- product\_category\_name\_translation

\*\*Key fields\*\*  
\- product\_id (PK)  
\- product\_category\_name (PT)  
\- product\_category\_name\_en (EN) via translation join

\*\*Rules\*\*  
\- left join translation on product\_category\_name  
\- keep original PT category even if EN is missing (EN can be null)

\---

\#\# dim\_date  
\*\*Sources\*\*  
\- generated calendar table that covers min(order\_purchase\_timestamp) to max(order\_purchase\_timestamp)  
\- optional extension to include delivered/estimated date range

\*\*Key fields\*\*  
\- date\_id (YYYYMMDD int) as PK  
\- year, quarter, month fields, year\_month, weekday fields, is\_weekend

\---

\#\# fact\_orders (order-level)  
\*\*Sources\*\*  
\- orders  
\- customers (for customer\_unique\_id)  
\- payments (aggregated to order\_id)

\*\*Join logic\*\*  
\- orders.customer\_id → customers.customer\_id → customers.customer\_unique\_id  
\- payments aggregated by order\_id → payment\_total, payment\_count

\*\*Derived fields\*\*  
\- purchase\_date\_id from order\_purchase\_timestamp  
\- delivered\_date\_id from order\_delivered\_customer\_date (nullable)  
\- is\_delivered \= 1 if order\_status \= 'delivered' else 0  
\- is\_canceled\_or\_unavailable \= 1 if order\_status in ('canceled','unavailable') else 0  
\- delivery\_days \= delivered\_customer\_date \- purchase\_timestamp (days; nullable)  
\- on\_time\_flag \= 1 if delivered\_customer\_date \<= estimated\_delivery\_date (nullable)

\*\*Notes\*\*  
\- payment\_total is the revenue source for core KPIs  
\- delivered orders should have payment\_total \> 0 (DQ blocker)

\---

\#\# fact\_order\_items (item-level)  
\*\*Sources\*\*  
\- order\_items  
\- products (for category via dim\_product)  
\- fact\_orders (for payment\_total allocation)

\*\*Join logic\*\*  
\- order\_items.order\_id → fact\_orders.order\_id  
\- order\_items.product\_id → dim\_product.product\_id

\*\*Derived fields\*\*  
\- item\_value \= price \+ freight\_value  
\- order\_item\_value\_share \= item\_value / SUM(item\_value) over order\_id  
\- allocated\_revenue \= fact\_orders.payment\_total \* order\_item\_value\_share

\*\*Notes\*\*  
\- allocated\_revenue ties product/category reporting back to payment-based revenue  
\- SUM(order\_item\_value\_share) should be \~1 per order (warning check)

\---

