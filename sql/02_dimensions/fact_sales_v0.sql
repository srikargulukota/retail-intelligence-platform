CREATE OR REPLACE TABLE WAREHOUSE.FACT_SALES_V0 AS
WITH first_two_weeks AS (
  SELECT week_seq
  FROM (
    SELECT DISTINCT d.week_seq
    FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE_SALES ss
    JOIN WAREHOUSE.DIM_DATE d
      ON ss.ss_sold_date_sk = d.date_sk
  )
  ORDER BY week_seq
  LIMIT 2
)
SELECT
  /* Keys */
  d.date_key,
  d.date_sk,
  d.week_seq,
  d.week_ending_date,

  p.product_key,
  s.store_key,
  r.state_cd      AS store_state_cd,
  r.census_region,
  r.census_division,
  r.timezone,

  c.channel_key,

  /* Identifiers */
  ss.ss_ticket_number AS ticket_number,

  /* Measures */
  ss.ss_quantity         AS quantity,
  ss.ss_sales_price      AS sales_price,
  ss.ss_ext_sales_price  AS ext_sales_amount,
  ss.ss_net_paid         AS net_paid,
  ss.ss_net_profit       AS net_profit

FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE_SALES ss
JOIN WAREHOUSE.DIM_DATE d
  ON ss.ss_sold_date_sk = d.date_sk
JOIN WAREHOUSE.DIM_PRODUCT p
  ON ss.ss_item_sk = p.product_key
JOIN WAREHOUSE.DIM_STORE s
  ON ss.ss_store_sk = s.store_key
JOIN WAREHOUSE.DIM_REGION r
  ON UPPER(TRIM(s.state_cd)) = r.state_cd
JOIN WAREHOUSE.DIM_CHANNEL c
  ON c.channel_name = 'STORE'
WHERE d.week_seq IN (SELECT week_seq FROM first_two_weeks);

