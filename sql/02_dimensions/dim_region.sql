-- dim_region: v0 (Census Region -> Division -> State) + timezone
-- Source: TPCDS store dimension for store sales v0

CREATE OR REPLACE TABLE WAREHOUSE.DIM_REGION AS
WITH states AS (
  SELECT DISTINCT
         UPPER(TRIM(s_state)) AS state_cd
  FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE
  WHERE s_state IS NOT NULL
),
mapped AS (
  SELECT
    state_cd,

    /* Census Region */
    CASE
      WHEN state_cd IN ('CT','ME','MA','NH','RI','VT','NJ','NY','PA') THEN 'Northeast'
      WHEN state_cd IN ('IL','IN','MI','OH','WI','IA','KS','MN','MO','NE','ND','SD') THEN 'Midwest'
      WHEN state_cd IN ('DE','FL','GA','MD','NC','SC','VA','DC','WV','AL','KY','MS','TN','AR','LA','OK','TX') THEN 'South'
      WHEN state_cd IN ('AZ','CO','ID','MT','NV','NM','UT','WY','AK','CA','HI','OR','WA') THEN 'West'
      ELSE 'Unknown'
    END AS census_region,

    /* Census Division */
    CASE
      WHEN state_cd IN ('CT','ME','MA','NH','RI','VT') THEN 'New England'
      WHEN state_cd IN ('NJ','NY','PA') THEN 'Mid Atlantic'

      WHEN state_cd IN ('IL','IN','MI','OH','WI') THEN 'East North Central'
      WHEN state_cd IN ('IA','KS','MN','MO','NE','ND','SD') THEN 'West North Central'

      WHEN state_cd IN ('DE','FL','GA','MD','NC','SC','VA','DC','WV') THEN 'South Atlantic'
      WHEN state_cd IN ('AL','KY','MS','TN') THEN 'East South Central'
      WHEN state_cd IN ('AR','LA','OK','TX') THEN 'West South Central'

      WHEN state_cd IN ('AZ','CO','ID','MT','NV','NM','UT','WY') THEN 'Mountain'
      WHEN state_cd IN ('AK','CA','HI','OR','WA') THEN 'Pacific'
      ELSE 'Unknown'
    END AS census_division,

    /* Timezone (operational attribute; separate from region/division hierarchy) */
    CASE
      WHEN state_cd IN ('CT','DE','DC','FL','GA','IN','KY','MA','MD','ME','MI','NC','NH','NJ','NY','OH','PA','RI','SC','TN','VA','VT','WV') THEN 'Eastern'
      WHEN state_cd IN ('AL','AR','IA','IL','KS','LA','MN','MO','MS','ND','NE','OK','SD','TX','WI') THEN 'Central'
      WHEN state_cd IN ('AZ','CO','ID','MT','NM','NV','UT','WY') THEN 'Mountain'
      WHEN state_cd IN ('CA','OR','WA') THEN 'Pacific'
      WHEN state_cd = 'AK' THEN 'Alaska'
      WHEN state_cd = 'HI' THEN 'Hawaii'
      ELSE 'Unknown'
    END AS timezone

  FROM states
)
SELECT
  state_cd,
  census_region,
  census_division,
  timezone,

  /* Security-ready placeholders (division-level RLS later) */
  CAST(NULL AS VARCHAR) AS division_manager_id,
  CAST(NULL AS VARCHAR) AS access_group
FROM mapped;
