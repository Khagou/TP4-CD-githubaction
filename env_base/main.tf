# service_account / main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "service_account" {
  source = "./service_account"
  gcp_project = var.gcp_project
}

module "artifact" {
  source = "./artifact_registry_repo"
  gcp_region = var.gcp_region
  docker-repo = var.docker-repo
}

module "network" {
  # depends_on = [ module.api ]
  source       = "./network"
  subnet_cidr = var.subnet_cidr
}

module "firewall" {
  # depends_on = [ module.api ]
  source           = "./firewall"
  network_self_link = module.network.network_self_link
  firewall_source = var.firewall_source
}