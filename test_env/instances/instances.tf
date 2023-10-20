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
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230918"
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

}

resource "null_resource" "upload_files" {
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
      "sudo apt-get update",
      "sudo apt-get install curl",
      "sudo apt-get install gnupg",
      "sudo apt-get install ca-certificates",
      "sudo apt-get install lsb-release",
      "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-pluginsudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-pluginlinux/ubuntu   $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin",
      "cd /TP4-CD-githubaction/docker-test && docker-compose up",
    ]
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
      "sudo apt-get update",
      "sudo apt-get install curl",
      "sudo apt-get install gnupg",
      "sudo apt-get install ca-certificates",
      "sudo apt-get install lsb-release",
      "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-pluginsudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-pluginlinux/ubuntu   $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin",
      "cd /TP4-CD-githubaction/docker-test && docker-compose up",
    ]
  }
}
