terraform {
  required_version = ">= 0.13"
  backend "gcs" {
    bucket = "tp4-tfstate"
    prefix = "terraform-workload/tfstate"
  }
  
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = ">= 3.64, < 5.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.64, < 5.0.0"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-github-actions-runners:gh-oidc/v3.1.1"
  }

  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-github-actions-runners:gh-oidc/v3.1.1"
  }

}