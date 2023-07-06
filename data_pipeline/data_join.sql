  -- co ppm --> Air quality
  -- pm25 --> air Quality
  -- Greenhouse gass -- co2e
SELECT
  road_config.road_id,
  road_config.osm_code,
  road_data.*,
  -- TODO: FIX THIS TO MAKE MORE SENSE
  IFNULL(road_data.co_ppm,0) +IFNULL(road_data.no2_ppb,0) + IFNULL(road_data.no_ppb,0) + IFNULL(road_data.pm25_ugm3,0) + IFNULL(road_data.co2_ppm, 0) AS weighted_co2e
FROM
  `qwiklabs-gcp-03-8a82d5a047b0.timestamp_road_mapping.timestamp_road_mapping` AS timestamp_road_mapping
LEFT JOIN
  `qwiklabs-gcp-03-8a82d5a047b0.road_config.road_config` road_config
ON
  road_config.road_id = timestamp_road_mapping.road_id
LEFT JOIN
  `qwiklabs-gcp-03-8a82d5a047b0.raw__road_data.raw_road_data_import` road_data
ON
  road_data.timestamp = timestamp_road_mapping.timestamp
WHERE
  timestamp_road_mapping.road_id IN(
  SELECT
    road_id
  FROM (
    SELECT
      COUNT(timestamp) AS ppm_count,
      road_id
    FROM
      `qwiklabs-gcp-03-8a82d5a047b0.timestamp_road_mapping.timestamp_road_mapping` AS timestamp_road_mapping
    GROUP BY
      road_id )
  WHERE
    ppm_count > 10 )
  AND road_data.timestamp IS NOT NULL
ORDER BY
  road_config.road_id