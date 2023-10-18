# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "instances" {
  depends_on = [ module.network ]
  source               = "./instances"
  subnet_self_link     = module.network.subnet_self_link
  # service_account_email = module.service_account.service_account_email
  dev = var.dev
  machine = var.machine
  sa_email = var.sa_email
}
