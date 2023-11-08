terraform {
  backend "gcs" {
    bucket = "tp4-tfstate"
    prefix = "terraform-test-prod/state"
  }
}