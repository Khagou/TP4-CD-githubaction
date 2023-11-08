terraform {
  backend "gcs" {
    bucket = "tp4tfstate"
    prefix = "terraform-test-prod/state"
  }
}