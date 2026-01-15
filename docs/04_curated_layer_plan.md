\# Curated Layer Plan (Local + S3)

\## Purpose  
Define how curated tables are stored, named, and versioned so the pipeline is repeatable and auditable.

---

\## Storage locations

\### Local (repo)  
- Raw snapshot: `data/raw/olist/2026-01-12/`  
- Curated snapshot: `data/curated/olist/2026-01-01/`  
- Reports: `reports/data\_quality/`

\### S3 (later)  
- Raw snapshot: `s3://<bucket>/raw/olist/2026-01-01/`  
- Curated snapshot: `s3://<bucket>/curated/olist/2026-01-01/`  
- Reports: `s3://<bucket>/reports/data\_quality/`

---

\## Curated outputs (tables)  
Each table is written as a single file per snapshot (simple + recruiter-friendly).

\- `dim\_date.csv`  
- `dim\_customer.csv`  
- `dim\_product.csv`  
- `fact\_orders.csv`  
- `fact\_order\_items.csv`

Optional (phase 2):  
- `dim\_seller.csv`  
- `fact\_reviews.csv`

---

\## Naming rules  
- Keep curated names stable: `dim\_\*`, `fact\_\*`  
- Use snapshot versioning via folder (not file name)  
- Timestamps stored as ISO datetime strings (or documented if converted)

---

\## File format (Phase 1)  
- Use \*\*CSV\*\* for simplicity and easy review  
- If upgrading later: Parquet for curated facts (not required)

---

\## Table contracts (what must exist)

\### dim\_date  
- date\_id, date, year, quarter, month\_num, month\_name, year\_month, week\_num, day\_of\_week\_num, day\_of\_week\_name, is\_weekend

\### dim\_customer  
- customer\_unique\_id, customer\_id, customer\_zip\_code\_prefix, customer\_city, customer\_state

\### dim\_product  
- product\_id, product\_category\_name, product\_category\_name\_en, product\_weight\_g, product\_length\_cm, product\_height\_cm, product\_width\_cm

\### fact\_orders  
- order\_id, customer\_unique\_id, order\_status  
- order\_purchase\_timestamp, order\_approved\_at, order\_delivered\_carrier\_date, order\_delivered\_customer\_date, order\_estimated\_delivery\_date  
- purchase\_date\_id, delivered\_date\_id  
- is\_delivered, is\_canceled\_or\_unavailable  
- delivery\_days, on\_time\_flag  
- payment\_total, payment\_count

\### fact\_order\_items  
- order\_id, order\_item\_id, product\_id  
- shipping\_limit\_date, price, freight\_value  
- item\_value, order\_item\_value\_share, allocated\_revenue

---

\## Snapshot rules  
- Curated tables are only published if the Data Quality report overall status = PASS.  
- Any FAIL in BLOCKER checks means: do not publish curated outputs for that run.

---

