resource "google_bigquery_table" "main" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.raw_data.dataset_id
  table_id            = "raw__road_data"
  schema              = file("schemata/schema_road_data.json")
}

resource "google_bigquery_table" "import" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.raw_data.dataset_id
  table_id            = "raw_road_data_import"
  schema              = file("schemata/schema_road_data.json")
}

resource "google_bigquery_table" "timestamp_road_mapping" {
  dataset_id = "timestamp_road_mapping"
  table_id   = "timestamp_road_mapping"
  schema     = file("schemata/schema_timestamp_mapping.json")
}

resource "google_bigquery_table" "road_config" {
  dataset_id = google_bigquery_dataset.road_config.dataset_id
  schema     = file("schemata/schema_road_config.json")
  table_id   = "road_config"
}

resource "google_bigquery_table" "road_config_geo" {
  dataset_id = google_bigquery_dataset.road_config.dataset_id
  schema     = file("schemata/schema_road_config_geo.json")
  table_id   = "road_config_geo"
}

resource "google_bigquery_table" "sensor_target" {
  dataset_id = google_bigquery_dataset.road_config.dataset_id
  schema     = file("schemata/schema_sensor_target.json")
  table_id   = "sensor_target"
}
