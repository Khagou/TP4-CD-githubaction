# service_account/service_account.tf

resource "google_service_account" "service_account_github_action" {
  account_id   = var.ansible_account_id
  display_name = var.ansible_display_name
}

resource "google_service_account_key" "service_account_github_action" {
  service_account_id = google_service_account.service_account_ansible
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "local_file" "service_account_key" {
  content  = base64decode(google_service_account_key.service_account_ansible)
  filename = var.ansible_key_filename
}

resource "google_project_iam_binding" "project" {
  project = var.gcp_project
  role    = "roles/viewer"

  members = [
    "serviceAccount:${google_service_account.service_account_ansible.email}",
  ]
}
