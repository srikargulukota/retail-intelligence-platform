-- dim_store: v0 (store attributes + geography join fields)
-- Source: TPCDS STORE dimension

CREATE OR REPLACE TABLE WAREHOUSE.DIM_STORE AS
SELECT
  s_store_sk   AS store_key,     -- surrogate key
  s_store_id   AS store_id,      -- business id
  s_store_name AS store_name,
  s_city       AS city,
  s_state      AS state_cd,
  s_zip        AS zip,
  s_county     AS county,
  s_market_id  AS market_id
FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE
WHERE s_store_sk IS NOT NULL;

INSERT INTO WAREHOUSE.DIM_REGION
(state_cd, census_region, census_division, timezone, division_manager_id, access_group)
SELECT
  'UN', 'Unknown', 'Unknown', 'Unknown', NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM WAREHOUSE.DIM_REGION WHERE state_cd = 'UN'
);

UPDATE WAREHOUSE.DIM_STORE
SET state_cd = 'UN'
WHERE state_cd IS NULL OR TRIM(state_cd) = '';
