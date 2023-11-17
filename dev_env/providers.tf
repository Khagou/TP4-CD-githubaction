terraform {
  backend "gcs" {
    bucket = "tp4testbucket"
    prefix = "terraform-env-dev/state"
  }
}