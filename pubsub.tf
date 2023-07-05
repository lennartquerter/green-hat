resource "google_pubsub_topic" "ingest-schema" {
  name = "green-hat-ingest-schema"

  depends_on = [google_pubsub_schema.schema]
  schema_settings {
    schema   = google_pubsub_schema.schema.id
    encoding = "JSON"
  }
}

resource "google_pubsub_schema" "schema" {
  definition = file("pubsub.proto")
  name       = "green-hat-schema-v1"
  type       = "PROTOCOL_BUFFER"
  timeouts {
    create = null
    delete = null
    update = null
  }
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
