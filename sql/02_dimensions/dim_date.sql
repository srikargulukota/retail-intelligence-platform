-- dim_date: v0 (supports weekly batching + week ending date = Friday)
-- Source: TPCDS date_dim

CREATE OR REPLACE TABLE WAREHOUSE.DIM_DATE AS
SELECT
  d_date_sk AS date_sk,                               -- TPCDS surrogate key for joins
  TO_NUMBER(TO_CHAR(d_date, 'YYYYMMDD')) AS date_key, -- human-friendly key
  d_date AS date,

  EXTRACT(YEAR FROM d_date)  AS year,
  EXTRACT(MONTH FROM d_date) AS month,
  EXTRACT(DAY FROM d_date)   AS day,
  EXTRACT(QUARTER FROM d_date) AS quarter,

  d_week_seq AS week_seq,

  DATEADD(
    day,
    5 - DAYOFWEEKISO(d_date),
    d_date
  ) AS week_ending_date

FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.DATE_DIM
WHERE d_date_sk IS NOT NULL;;

