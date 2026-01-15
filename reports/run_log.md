## Run: 2026-01-08

* Snapshot: data/raw/olist/2026-01-01/
* Status: PASS
* DQ Report: reports/data\_quality/data\_quality\_report\_2026-01-01.md
* Published curated outputs: YES
* Curated tables:

  * data/curated/olist/2026-01-01/dim\_date.csv
  * data/curated/olist/2026-01-01/dim\_customer.csv
  * data/curated/olist/2026-01-01/dim\_product.csv
  * data/curated/olist/2026-01-01/fact\_orders.csv
  * data/curated/olist/2026-01-01/fact\_order\_items.csv

* Notes:

  * 1 delivered order missing payment rows; patched payment\_total using SUM(price + freight).
  * Category translation coverage: 98.11% (623 products missing EN category).
