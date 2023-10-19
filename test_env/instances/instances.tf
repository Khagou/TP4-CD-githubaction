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
    ssh-keys = "google-ssh {\"userName\":\"${var.sa_email}\",\"expireOn\":\"2025-12-31T23:59:59Z\"}"
  }
}

resource "null_resource" "upload_files" {
  triggers = {
    instance_id = google_compute_instance.test_instance.id
  }

  provisioner "local-exec" {
    command = "scp -r /home/runner/work/TP4-CD-githubaction/TP4-CD-githubaction ${var.sa_email}@${google_compute_instance.test_instance.network_interface.0.access_config.0.nat_ip}:~/"
  }
}

resource "null_resource" "remote_exec" {
  triggers = {
    instance_id = google_compute_instance.test_instance.id
  }

  provisioner "remote-exec" {
    connection {
      host        = google_compute_instance.test_instance.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.sa_email
      private_key = var.private_key
    }

    inline = [
      "cd /TP4-CD-githubaction/docker-test && docker-compose up",
    ]
  }
}