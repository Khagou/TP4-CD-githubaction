resource "google_service_account" "gke" {
  account_id   = "gke-service-account"
  display_name = "Service Account for GKE"
}
resource "google_project_iam_binding" "gke_container_admin" {
  project  = var.gcp_project
  role               = "roles/container.admin"
   members = [
    "serviceAccount:${google_service_account.gke.email}",
  ]
}
resource "google_project_iam_binding" "gke_storage_admin" {
  project  = var.gcp_project
  role               = "roles/storage.admin"
   members = [
    "serviceAccount:${google_service_account.gke.email}",
  ]
}
resource "google_project_iam_binding" "gke_cluster_viewer" {
  project  = var.gcp_project
  role               = "roles/container.clusterViewer"
   members = [
    "serviceAccount:${google_service_account.gke.email}",
  ]
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.gcp_zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.node_pool_name
  location   = var.gcp_region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}