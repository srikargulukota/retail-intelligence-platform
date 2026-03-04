# Data Model

The platform uses a dimensional modeling approach.

Core tables:

Fact Tables
- fact_sales
- fact_returns

Dimension Tables
- dim_date
- dim_product
- dim_customer
- dim_store
- dim_region
- dim_channel

Fact tables are stored at the line-item grain to allow flexible analysis across dimensions.
