terraform {
  backend "gcs" {
    bucket = "tp4testbucket" # Change me
    prefix = "terraform-test-prod/state"
  }
}