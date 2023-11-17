terraform {
  backend "gcs" {
    bucket = "tp4testbucket"
    prefix = "terraform-test-prod/state"
  }
}