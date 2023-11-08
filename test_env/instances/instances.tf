# instances/instances.tf

#################################################
############# DEV INSTANCE CONFIG ###############
#################################################

resource "google_compute_instance" "test_instance" {
  name         = var.test
  machine_type = var.machine
  tags         = ["test"]

  boot_disk {
    initialize_params {
      image = "=projects/ubuntu-os-cloud/global/images/ubuntu-2304-lunar-amd64-v20231003"
    }
  }

  network_interface {
    subnetwork = var.subnetwork

    access_config {
      # Autoriser l'accès par une adresse IP externe
    }
  }
  service_account {
    email = var.sa_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
