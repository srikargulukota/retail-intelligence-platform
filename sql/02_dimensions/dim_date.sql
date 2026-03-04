-- dim_date: v0 (supports weekly batching + week ending date = Friday)
-- Source: TPCDS date_dim

CREATE OR REPLACE TABLE WAREHOUSE.DIM_DATE AS
SELECT
  /* Use yyyymmdd as a simple, portable date key */
  TO_NUMBER(TO_CHAR(d_date, 'YYYYMMDD')) AS date_key,
  d_date AS date,

  EXTRACT(YEAR FROM d_date)  AS year,
  EXTRACT(MONTH FROM d_date) AS month,
  EXTRACT(DAY FROM d_date)   AS day,

  /* Quarter as 1-4 */
  EXTRACT(QUARTER FROM d_date) AS quarter,

  /* TPCDS provides a week sequence; keep it for batch simulation */
  d_week_seq AS week_seq,

  /* "Update date": Friday week-ending date */
  DATEADD(
    day,
    5 - DAYOFWEEKISO(d_date),  -- ISO: Mon=1 ... Sun=7, so Fri=5
    d_date
  ) AS week_ending_date

FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.DATE_DIM
WHERE d_date IS NOT NULL;

