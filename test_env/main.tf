# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "instances" {
  source               = "./instances"
  subnet_self_link     = module.network.subnet_self_link
  # service_account_email = module.service_account.service_account_email
  test = var.test
  machine = var.machine
  sa_email = var.sa_email
}
