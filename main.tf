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

  depends_on = [google_pubsub_schema.schema]
  schema_settings {
    schema   = google_pubsub_schema.schema.id
    encoding = "JSON"
  }
}

resource "google_bigquery_dataset" "raw_data" {
  dataset_id = "raw__road_data"
}

resource "google_bigquery_table" "main" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.raw_data.dataset_id
  table_id            = "raw__road_data"
  schema              = <<EOF
  [
  {
    "description": "GPS Timestamp in UTC",
    "mode": "NULLABLE",
    "name": "timestamp",
    "type": "TIMESTAMP"
  },
  {
    "description": "GPS position",
    "mode": "NULLABLE",
    "name": "latitude",
    "type": "FLOAT64"
  },
  {
    "description": "GPS position",
    "mode": "NULLABLE",
    "name": "longitude",
    "type": "FLOAT64"
  },
  {
    "description": "NO concentration in parts per billion",
    "mode": "NULLABLE",
    "name": "no_ppb",
    "type": "FLOAT64"
  },
  {
    "description": "NO2 concentration in parts per billion",
    "mode": "NULLABLE",
    "name": "no2_ppb",
    "type": "FLOAT64"
  },
  {
    "description": "O3 concentration in parts per billion",
    "mode": "NULLABLE",
    "name": "o3_ppb",
    "type": "FLOAT64"
  },
  {
    "description": "CO concentration in parts per million",
    "mode": "NULLABLE",
    "name": "co_ppm",
    "type": "FLOAT64"
  },
  {
    "description": "CO2 concentration in parts per million",
    "mode": "NULLABLE",
    "name": "co2_ppm",
    "type": "FLOAT64"
  },
  {
    "description": "PM channel 1 measurement in counts per litre",
    "mode": "NULLABLE",
    "name": "pmch1_perl",
    "type": "INTEGER"
  },
  {
    "description": "PM channel 2 measurement in counts per litre",
    "mode": "NULLABLE",
    "name": "pmch2_perl",
    "type": "INTEGER"
  },
  {
    "description": "PM channel 3 measurement in counts per litre",
    "mode": "NULLABLE",
    "name": "pmch3_perl",
    "type": "INTEGER"
  },
  {
    "description": "PM channel 4 measurement in counts per litre",
    "mode": "NULLABLE",
    "name": "pmch4_perl",
    "type": "INTEGER"
  },
  {
    "description": "PM channel 5 measurement in counts per litre",
    "mode": "NULLABLE",
    "name": "pmch5_perl",
    "type": "INTEGER"
  },
  {
    "description": "PM channel 6 measurement in counts per litre",
    "mode": "NULLABLE",
    "name": "pmch6_perl",
    "type": "INTEGER"
  },
  {
    "description": "PM2.5 concentration in µg/m3",
    "mode": "NULLABLE",
    "name": "pm25_ugm3",
    "type": "FLOAT64"
  }
]
EOF
}

resource "google_pubsub_subscription" "raw_data_ingest" {
  name  = "green-hat"
  topic = google_pubsub_topic.ingest.name

  bigquery_config {
    table            = "${google_bigquery_table.main.project}:${google_bigquery_table.main.dataset_id}.${google_bigquery_table.main.table_id}"
    use_topic_schema = true
  }
}

resource "google_pubsub_schema" "schema" {
  definition = "syntax = \"proto3\";\nmessage RXEvent {\n  optional string timestamp = 1; // GPS Timestamp in UTC\n  optional double latitude = 2; // GPS position \n  optional double longitude = 3; // GPS position \n  optional double no_ppb = 4; // NO concentration in parts per billion\n  optional double no2_ppb = 5; // NO2 concentration in parts per billion\n  optional double o3_ppb = 6; // O3 concentration in parts per billion\n  optional double co_ppm = 7; // CO concentration in parts per million\n  optional double co2_ppm = 8; // CO2 concentration in parts per million\n  optional int32 pmch1_perl = 9; // PM channel 1 measurement in counts per litre\n  optional int32 pmch2_perl = 10; // PM channel 2 measurement in counts per litre\n  optional int32 pmch3_perl = 11; // PM channel 3 measurement in counts per litre\n  optional int32 pmch4_perl = 12; // PM channel 4 measurement in counts per litre\n  optional int32 pmch5_perl = 13; // PM channel 5 measurement in counts per litre\n  optional int32 pmch6_perl = 14; // PM channel 6 measurement in counts per litre\n  optional double pm25_ugm3 = 15; // PM2.5 concentration in µg/m3\n}"
  name       = "green-hat-schema-v1"
  project    = "qwiklabs-gcp-02-f86a07b06de4"
  type       = "PROTOCOL_BUFFER"
  timeouts {
    create = null
    delete = null
    update = null
  }
}
