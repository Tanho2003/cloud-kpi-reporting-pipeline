\copy bi.dim_date FROM 'C:/Users/TAN/OneDrive/Cloud_KPI_Reporting_Pipeline/data/curated/olist/2026-01-12/dim_date.csv' WITH (FORMAT csv, HEADER true, NULL '', ENCODING 'UTF8');
\copy bi.dim_customer FROM 'C:/Users/TAN/OneDrive/Cloud_KPI_Reporting_Pipeline/data/curated/olist/2026-01-12/dim_customer.csv' WITH (FORMAT csv, HEADER true, NULL '', ENCODING 'UTF8');
\copy bi.dim_product FROM 'C:/Users/TAN/OneDrive/Cloud_KPI_Reporting_Pipeline/data/curated/olist/2026-01-12/dim_product.csv' WITH (FORMAT csv, HEADER true, NULL '', ENCODING 'UTF8');
\copy bi.fact_orders FROM 'C:/Users/TAN/OneDrive/Cloud_KPI_Reporting_Pipeline/data/curated/olist/2026-01-12/fact_orders.csv' WITH (FORMAT csv, HEADER true, NULL '', ENCODING 'UTF8');
\copy bi.fact_order_items FROM 'C:/Users/TAN/OneDrive/Cloud_KPI_Reporting_Pipeline/data/curated/olist/2026-01-12/fact_order_items.csv' WITH (FORMAT csv, HEADER true, NULL '', ENCODING 'UTF8');
