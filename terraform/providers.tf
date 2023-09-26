provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

terraform {
  backend "gcs" {
    bucket = "tp4-cd-tfstate"
    prefix = "terraform/state"
  }
}