CREATE OR REPLACE MODEL
  `qwiklabs-gcp-03-8a82d5a047b0.data_frames.models-1` OPTIONS(MODEL_TYPE='ARIMA_PLUS',
    time_series_timestamp_col='dte',
    time_series_data_col='avg_weighted_co2e',
    time_series_id_col='road_id') AS
SELECT
  dte,
  avg_weighted_co2e,
  road_id
FROM
  `qwiklabs-gcp-03-8a82d5a047b0.data_frames.weighted_co2e`
  --   --- forecast the values
  CREATE TABLE  `qwiklabs-gcp-03-8a82d5a047b0.data_frames.predictions-1` AS
  SELECT
    *
  FROM
    ML.FORECAST(MODEL `qwiklabs-gcp-03-8a82d5a047b0.data_frames.models-1`,
                STRUCT(30 AS horizon, 0.8 AS confidence_level))