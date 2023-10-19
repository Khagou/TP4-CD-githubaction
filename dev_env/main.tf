# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "instances" {
  source               = "./instances"
  subnetwork    = var.subnetwork
  dev = var.dev
  machine = var.machine
  sa_email = var.sa_email
  docker_image_version = var.docker_image_version
}
