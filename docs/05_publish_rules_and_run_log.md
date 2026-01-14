\# Publish Rules \+ Run Log Standard

\#\# Purpose  
Make each refresh auditable: what ran, what passed/failed, what got published.

\---

\#\# Curated folder structure (local)  
Create these folders:

\- data/curated/olist/2026-01-12/  
  \- dim\_date.csv  
  \- dim\_customer.csv  
  \- dim\_product.csv  
  \- fact\_orders.csv  
  \- fact\_order\_items.csv

Create these report folders:

\- reports/data\_quality/  
\- reports/run\_logs/

\---

\#\# Publish rule (gate)  
Curated outputs are \*\*published only if\*\*:  
\- Data Quality Report overall status \= \*\*PASS\*\*  
\- All \*\*BLOCKER\*\* checks \= PASS

If any BLOCKER fails:  
\- Do \*\*not\*\* publish curated tables  
\- Save the failing DQ report  
\- Log the failure in the run log

\---

\#\# Run log format (every run)  
Each pipeline run must record:  
\- Run date/time  
\- Dataset snapshot version  
\- Outcome (PASS/FAIL)  
\- Curated tables produced (yes/no)  
\- Key row counts (raw vs curated)  
\- Notes / remediation

\---

\#\# Where the logs live  
\- Data quality report:  
  \- reports/data\_quality/data\_quality\_report\_YYYY-MM-DD.md  
\- Run log append-only record:  
  \- reports/run\_log.md  
\- Optional per-run log file:  
  \- reports/run\_logs/run\_YYYY-MM-DD.md

