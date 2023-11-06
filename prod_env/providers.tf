terraform {
  backend "gcs" {
    bucket = "tp4tfstate"
    prefix = "terraform-env-prod/state"
  }
}