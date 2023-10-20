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
  metadata = {
    ssh-keys = "${file(var.pub_key)}"
  }
  provisioner "file" {
    connection {
      host        = google_compute_instance.test_instance.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      private_key = var.private_key
    }
    source = "/home/runner/work/TP4-CD-githubaction/TP4-CD-githubaction"
    destination = "~/TP4-CD-githubaction"
  }

  provisioner "remote-exec" {
    connection {
      host        = google_compute_instance.test_instance.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      private_key = var.private_key
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install docker-compose-plugin",
      "cd /TP4-CD-githubaction/docker-test && docker-compose up",
    ]
  }
}

# resource "null_resource" "upload_files" {
#   triggers = {
#     instance_id = google_compute_instance.test_instance.id
#   }

# }

# resource "null_resource" "remote_exec" {
#   triggers = {
#     instance_id = google_compute_instance.test_instance.id
#   }

# }
