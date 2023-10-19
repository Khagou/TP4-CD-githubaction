# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "instances" {
  source               = "./instances"
  subnetwork    = var.subnetwork
  # service_account_email = module.service_account.service_account_email
  test = var.test
  machine = var.machine
  sa_email = var.sa_email
  private_key = var.private_key
}
