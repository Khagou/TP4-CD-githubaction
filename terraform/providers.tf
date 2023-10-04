

terraform {
  backend "gcs" {
    bucket = "tp4-cd-tfstate"
    prefix = "terraform/state"
  }
}