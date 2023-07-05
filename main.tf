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
