-- mart_sales_weekly_v0: dashboard-serving aggregate mart (fast)
-- Grain: week x geo x product hierarchy x channel

CREATE OR REPLACE TABLE MARTS.MART_SALES_WEEKLY_V0 AS
SELECT
  /* Time */
  week_seq,
  week_ending_date,

  /* Geography hierarchy */
  store_state_cd AS state_cd,
  census_region,
  census_division,
  timezone,

  /* Channel */
  channel_key,

  /* Product hierarchy */
  p.category,
  p.class,
  p.brand,

  /* Metrics */
  SUM(ext_sales_amount) AS revenue,
  SUM(net_paid)         AS net_paid,
  SUM(net_profit)       AS net_profit,
  SUM(quantity)         AS units,

  COUNT(DISTINCT ticket_number) AS orders,

  /* Convenience metric (avoid div-by-zero) */
  CASE WHEN COUNT(DISTINCT ticket_number) = 0
       THEN NULL
       ELSE SUM(ext_sales_amount) / COUNT(DISTINCT ticket_number)
  END AS avg_order_value

FROM WAREHOUSE.FACT_SALES_V0 f
JOIN WAREHOUSE.DIM_PRODUCT p
  ON f.product_key = p.product_key
GROUP BY
  week_seq,
  week_ending_date,
  store_state_cd,
  census_region,
  census_division,
  timezone,
  channel_key,
  p.category,
  p.class,
  p.brand;
