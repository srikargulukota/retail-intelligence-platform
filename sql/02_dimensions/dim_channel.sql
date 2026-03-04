-- dim_channel: v0 (channels for multi-channel retail)

CREATE OR REPLACE TABLE WAREHOUSE.DIM_CHANNEL AS
SELECT * FROM (
  SELECT 1 AS channel_key, 'STORE'   AS channel_name UNION ALL
  SELECT 2 AS channel_key, 'WEB'     AS channel_name UNION ALL
  SELECT 3 AS channel_key, 'CATALOG' AS channel_name
);

-- SELECT * FROM WAREHOUSE.DIM_CHANNEL ORDER BY channel_key;
