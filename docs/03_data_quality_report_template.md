\# Data Quality Report — YYYY-MM-DD

\#\# Run Metadata  
\- Run date: YYYY-MM-DD  
\- Dataset snapshot: data/raw/olist/2026-01-12/  
\- Curated output target: data/curated/olist/  
\- Overall status: PASS / FAIL

\---

\#\# Row Counts (Raw → Curated)  
| Table | Raw Rows | Curated Rows | Notes |  
|------|----------|--------------|------|  
| orders |  |  |  |  
| order\_items |  |  |  |  
| order\_payments |  |  |  |  
| customers |  |  |  |  
| products |  |  |  |  
| dim\_date |  |  |  |  
| dim\_customer |  |  |  |  
| dim\_product |  |  |  |  
| fact\_orders |  |  |  |  
| fact\_order\_items |  |  |  |

\---

\#\# Check Results Summary  
| Severity | Passed | Failed |  
|---------|--------|--------|  
| BLOCKER |  |  |  
| WARNING |  |  |

\---

\#\# BLOCKER Checks (must pass)  
| Check | Table | Result | Evidence / Notes |  
|------|-------|--------|------------------|  
| Required raw files exist | raw | PASS/FAIL |  |  
| Schema present | raw | PASS/FAIL |  |  
| PK unique \+ not null | dim\_customer | PASS/FAIL |  |  
| PK unique \+ not null | dim\_product | PASS/FAIL |  |  
| dim\_date covers purchase dates | dim\_date | PASS/FAIL |  |  
| PK unique \+ not null | fact\_orders | PASS/FAIL |  |  
| Delivered orders have payment\_total \> 0 | fact\_orders | PASS/FAIL |  |  
| PK unique \+ not null | fact\_order\_items | PASS/FAIL |  |  
| price/freight \>= 0 | fact\_order\_items | PASS/FAIL |  |  
| RI: orders→customers | RI | PASS/FAIL |  |  
| RI: items→orders | RI | PASS/FAIL |  |  
| RI: items→products | RI | PASS/FAIL |  |

\---

\#\# WARNING Checks (log \+ monitor)  
| Check | Table | Result | Evidence / Notes |  
|------|-------|--------|------------------|  
| Category translation coverage \>= 95% | dim\_product | PASS/FAIL |  |  
| order\_status domain check | fact\_orders | PASS/FAIL |  |  
| delivery\_days \>= 0 | fact\_orders | PASS/FAIL |  |  
| SUM(item share) ≈ 1 per order | fact\_order\_items | PASS/FAIL |  |

\---

\#\# Decision  
\- Publish curated outputs? YES / NO  
\- If NO: list the blocker failures and remediation steps.

\#\# Remediation Notes  
\- (What  changed / what to fix next run)

