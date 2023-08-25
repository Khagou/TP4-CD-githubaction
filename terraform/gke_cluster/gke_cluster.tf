resource "google_container_cluster" "gke_cluster" {
  name               = var.cluster_name
  location           = var.gcp_region
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}