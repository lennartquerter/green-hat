terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.72.0"
    }
  }
}

provider "google" {
  project = "qwiklabs-gcp-02-f86a07b06de4"
  region  = "eu-west1"
}

resource "google_pubsub_topic" "ingest" {
  name = "green-hat-ingest"
}

resource "google_bigquery_dataset" "raw_data" {
  dataset_id = "raw__road_data"
}

resource "google_bigquery_table" "main" {
  dataset_id = google_bigquery_dataset.raw_data.dataset_id
  table_id   = "raw__road_data"
}

resource "google_pubsub_subscription" "raw_data_ingest" {
  name  = "green-hat"
  topic = google_pubsub_topic.ingest.name

  bigquery_config {
    table = "${google_bigquery_table.main.project}:${google_bigquery_table.main.dataset_id}.${google_bigquery_table.main.table_id}"
  }
}
