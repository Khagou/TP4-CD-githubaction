# service_account / service_account.tf

resource "google_service_account" "terraform" {
  project      = var.gcp_project
  account_id   = "terraform"
  display_name = "Service Account used for Terraform deployment"
}
resource "google_project_iam_binding" "terraform" {
  project  = var.gcp_project
  role               = "roles/editor"
   members = [
    "serviceAccount:${google_service_account.terraform.email}",
  ]
}

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