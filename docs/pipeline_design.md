# Pipeline Design

The pipeline simulates incremental weekly batch ingestion.

Steps:

1. Weekly data batches are processed based on week sequence.
2. Data is appended to fact tables.
3. Dimension tables are updated when necessary.
4. Analytics marts are refreshed.
5. Tableau dashboards update automatically.

This approach demonstrates scalable data ingestion patterns used in production BI platforms.
