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