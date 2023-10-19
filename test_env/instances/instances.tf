# instances/instances.tf

############# DEV INSTANCE CONFIG ###############
#################################################

resource "google_compute_instance" "test_instance" {
  name         = var.test
  machine_type = var.machine
  tags         = ["test"]

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
    provisioner "file" {
    source      = "/home/runner/work/TP4-CD-githubaction/TP4-CD-githubaction"
    destination = "/TP4-CD-githubaction"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /TP4-CD-githubaction/docker-test",
      "docker-compose up",
    ]
  }

  service_account {
    email = var.sa_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
