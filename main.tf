terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.72.0"
    }
  }
}

provider "google" {
  project = "qwiklabs-gcp-03-8a82d5a047b0"
  region  = "eu-west1"
}

data "google_project" "project" {
}

resource "google_pubsub_topic" "ingest-schema" {
  name = "green-hat-ingest-schema"

  depends_on = [google_pubsub_schema.schema]
  schema_settings {
    schema   = google_pubsub_schema.schema.id
    encoding = "JSON"
  }
}

resource "google_bigquery_dataset" "raw_data" {
  dataset_id = "raw__road_data"
  location   = "europe-west1"
}

resource "google_bigquery_table" "main" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.raw_data.dataset_id
  table_id            = "raw__road_data"
  schema              = file("schema.json")
}

resource "google_pubsub_subscription" "raw_data_ingest" {
  name  = "green-hat"
  topic = google_pubsub_topic.ingest-schema.name

  bigquery_config {
    table            = "${google_bigquery_table.main.project}:${google_bigquery_table.main.dataset_id}.${google_bigquery_table.main.table_id}"
    use_topic_schema = true
  }
  depends_on = [google_project_iam_member.viewer, google_project_iam_member.editor]
}

resource "google_pubsub_schema" "schema" {
  definition = "syntax = \"proto3\";\nmessage RXEvent {\n  optional string timestamp = 1; // GPS Timestamp in UTC\n  optional double latitude = 2; // GPS position \n  optional double longitude = 3; // GPS position \n  optional double no_ppb = 4; // NO concentration in parts per billion\n  optional double no2_ppb = 5; // NO2 concentration in parts per billion\n  optional double o3_ppb = 6; // O3 concentration in parts per billion\n  optional double co_ppm = 7; // CO concentration in parts per million\n  optional double co2_ppm = 8; // CO2 concentration in parts per million\n  optional int32 pmch1_perl = 9; // PM channel 1 measurement in counts per litre\n  optional int32 pmch2_perl = 10; // PM channel 2 measurement in counts per litre\n  optional int32 pmch3_perl = 11; // PM channel 3 measurement in counts per litre\n  optional int32 pmch4_perl = 12; // PM channel 4 measurement in counts per litre\n  optional int32 pmch5_perl = 13; // PM channel 5 measurement in counts per litre\n  optional int32 pmch6_perl = 14; // PM channel 6 measurement in counts per litre\n  optional double pm25_ugm3 = 15; // PM2.5 concentration in µg/m3\n}"
  name       = "green-hat-schema-v1"
  type       = "PROTOCOL_BUFFER"
  timeouts {
    create = null
    delete = null
    update = null
  }
}

resource "google_bigquery_dataset" "road_config" {
  dataset_id = "road_config"
  location   = "europe-west1"
  timeouts {
    create = null
    delete = null
    update = null
  }
}

resource "google_project_iam_member" "viewer" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "editor" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_bigquery_dataset" "timestamp_road_mapping" {
  dataset_id = "timestamp_road_mapping"
  location   = "europe-west1"
}

import {
  to = google_bigquery_table.timestamp_road_mapping
  id = "qwiklabs-gcp-03-8a82d5a047b0/timestamp_road_mapping/timestamp_road_mapping"
}
resource "google_bigquery_table" "timestamp_road_mapping" {
  dataset_id = "timestamp_road_mapping"
  table_id   = "timestamp_road_mapping"
  schema     = file("schema_timestamp_mapping.json")
}
