# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

# module "api" {
#   source = "./api"
#   project = var.gcp_project
# }
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
# module "service_account" {
#   source      = "./service_account"
#   gcp_project = var.gcp_project
#   key_filename = var.key_filename
#   account_id   = var.account_id
#   display_name = var.display_name
# }
module "gce-container" {
  depends_on = [ module.network ]
  source = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"  # Upgrade the version if necessary.

  container = {
    image = "europe-west1-docker.pkg.dev/tp4-cd-400812/docker-repo/tp4-cd:1"
  }

  cos_image_name = "cos-109-17800-0-45"
}

module "instances" {
  depends_on = [ module.gce-container ]
  source               = "./instances"
  subnet_self_link     = module.network.subnet_self_link
  # service_account_email = module.service_account.service_account_email
  dev = var.dev
  test = var.test
  machine = var.machine
}

# module "artifact" {
#   source = "./artifact_registry_repo"
#   gcp_region = var.gcp_region
#   docker-repo = var.docker-repo
# }

