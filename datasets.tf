resource "google_bigquery_dataset" "raw_data" {
  dataset_id = "raw__road_data"
  location   = "europe-west1"
}

resource "google_bigquery_dataset" "road_config" {
  dataset_id = "road_config"
  location   = "europe-west1"
}

resource "google_bigquery_dataset" "timestamp_road_mapping" {
  dataset_id = "timestamp_road_mapping"
  location   = "europe-west1"
}
