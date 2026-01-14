TRUNCATE TABLE bi.fact_orders;

\copy bi.fact_orders FROM 'C:/Users/TAN/OneDrive/Cloud_KPI_Reporting_Pipeline/data/curated/olist/2026-01-12/fact_orders.csv' WITH (FORMAT csv, HEADER true, NULL '', ENCODING 'UTF8');
