# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "instances" {
  source               = "./instances"
  subnetwork    = var.subnetwork
  test = var.test
  machine = var.machine
  sa_email = var.sa_email
  user = var.user
}
