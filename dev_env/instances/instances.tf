# instances/instances.tf

############# DEV INSTANCE CONFIG ###############
#################################################

module "gce-container" {
  source = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"  # Upgrade the version if necessary.

  container = {
    image = "europe-west1-docker.pkg.dev/tp4-cd-400812/docker-repo/tp4-cd:latest"
  }

  cos_image_name = "cos-109-17800-0-45"
}

resource "google_compute_instance" "dev_instance" {
  name         = var.dev
  machine_type = var.machine
  tags         = ["dev"]

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/cos-109-17800-0-45"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {
      # Autoriser l'accès par une adresse IP externe
    }
  }
    metadata = {
    # Required metadata key.
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    # Required label key.
    container-vm = module.gce-container.vm_container_label
  }
  service_account {
    email = var.sa_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
