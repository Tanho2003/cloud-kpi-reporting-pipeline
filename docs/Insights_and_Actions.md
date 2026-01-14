\# Insights & Actions — Cloud KPI Dashboard (Olist)

\*\*Snapshot:\*\* 2026-01-12    
\*\*KPI rules:\*\* Core KPIs use \*\*delivered orders only\*\*. Trend date \= \*\*purchase date\*\*. Revenue \= \*\*sum(payment\_total)\*\*.

\---

\#\# Executive Summary  
The dashboard summarizes commerce performance from raw → curated → Postgres → Power BI. In this snapshot, the business delivered \*\*96,478 orders\*\* and generated \*\*15,422,605.23 BRL\*\* in delivered revenue (AOV ≈ \*\*159.86 BRL\*\*). Exceptions (canceled \+ unavailable) are low overall (\*\*\~1.24% of all orders\*\*) but should be monitored as an early warning signal.

\---

\#\# Key Insights (What happened \+ evidence)  
1\) \*\*Delivered performance is strong and stable\*\*  
\- Evidence: Delivered Orders \= \*\*96,478\*\*; Delivered Revenue \= \*\*15,422,605.23 BRL\*\*; AOV ≈ \*\*159.86 BRL\*\*.

2\) \*\*Exceptions are small but worth tracking\*\*  
\- Evidence: canceled \= \*\*625 (\~0.63%)\*\*, unavailable \= \*\*609 (\~0.61%)\*\*, combined exceptions \= \*\*1,234 (\~1.24%)\*\* out of \*\*99,441\*\* total orders.  
\- Why this matters: even small spikes can signal inventory, payment, or fulfillment issues.

3\) \*\*Revenue concentration (fill from dashboard)\*\*  
\- Evidence: Top categories by delivered allocated revenue: \*\*\[Category 1\]\*\*, \*\*\[Category 2\]\*\*, \*\*\[Category 3\]\*\*.  
\- Evidence: Top states by delivered orders: \*\*\[State 1\]\*\*, \*\*\[State 2\]\*\*, \*\*\[State 3\]\*\*.

4\) \*\*Data quality note (impact on category reporting)\*\*  
\- Evidence: English category translation coverage \= \*\*98.11%\*\* (623 products missing EN category).  
\- Impact: category charts may slightly under-report / show “blank” categories unless we use a fallback label.

\---

\#\# Actions (So what should we do)  
\#\#\# A) Operations / Risk  
\- \*\*Set an exception threshold:\*\* alert if (canceled \+ unavailable) exceeds \*\*2.0%\*\* in a month or spikes week-over-week.  
\- \*\*Drill down exceptions:\*\* slice canceled/unavailable by \*\*state \+ category\*\* to find where issues cluster (e.g., one region or category).

\#\#\# B) Commercial / Growth  
\- \*\*Prioritize top categories:\*\* feature the top 2 categories in promos and homepage placement (highest delivered revenue contribution).  
\- \*\*Geo targeting:\*\* focus paid media or offers on the top states with strong order volume, and test growth campaigns in the next tier states.

\#\#\# C) Data / Reporting  
\- \*\*Fix “blank category” display:\*\* create a display field that falls back to Portuguese when EN is missing (keeps visuals clean).  
\- \*\*Lock KPI definitions:\*\* keep “delivered-only” as the default reporting scope, and label any “all status” views clearly.

\---

\#\# Next questions to answer  
\- Is revenue growth driven by \*\*more orders\*\* or \*\*higher AOV\*\*?  
\- Which categories/states have the \*\*highest exception rate\*\* (not just highest volume)?  
\- What is the \*\*on-time delivery rate\*\* trend, and does it correlate with cancellations?

