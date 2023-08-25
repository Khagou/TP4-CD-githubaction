# instances/instances.tf

############### TEST INSTANCE CONFIG #################

# resource "google_compute_instance" "test_instance" {
#   name         = var.test
#   machine_type = var.machine
#   tags         = ["test"]


#   service_account {
#     email  = var.service_account_email
#     scopes = ["cloud-platform"]
#   }

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     subnetwork = var.subnet_self_link
#     access_config {
#       # Autoriser l'accès par une adresse IP externe
#     }
#   }
# }


############# DEV INSTANCE CONFIG ###############

resource "google_compute_instance" "dev_instance" {
  name         = var.dev
  machine_type = var.machine
  tags         = ["dev"]


  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {
      # Autoriser l'accès par une adresse IP externe
    }
  }
}