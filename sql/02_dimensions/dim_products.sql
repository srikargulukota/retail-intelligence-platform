-- dim_product: v0 (minimal product drill-down)
-- Source: TPCDS ITEM dimension

CREATE OR REPLACE TABLE WAREHOUSE.DIM_PRODUCT AS
SELECT
  i_item_sk   AS product_key,      -- surrogate key
  i_item_id   AS item_id,          -- business id
  i_item_desc AS product_name,      -- description/name
  i_category  AS category,
  i_class     AS class,
  i_brand     AS brand
FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.ITEM
WHERE i_item_sk IS NOT NULL;

-- VALIDATION:
--------------
-- Uniqueness: product_key should be unique
--SELECT product_key, COUNT(*) AS cnt
-- FROM WAREHOUSE.DIM_PRODUCT
-- GROUP BY 1
-- HAVING COUNT(*) > 1;

-- Basic row count
-- SELECT COUNT(*) AS product_rows
-- FROM WAREHOUSE.DIM_PRODUCT;

-- Null check (optional)
-- SELECT
--   SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
--   SUM(CASE WHEN class    IS NULL THEN 1 ELSE 0 END) AS null_class,
--   SUM(CASE WHEN brand    IS NULL THEN 1 ELSE 0 END) AS null_brand
-- FROM WAREHOUSE.DIM_PRODUCT;
