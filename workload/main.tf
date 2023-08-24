provider "google" {
  project     = local.project_id
  region      = "eu-west1"
  zone        = "eu-west1-b"
  scopes      = [ "https://www.googleapis.com/auth/cloud-platform" ]
}

locals {
  project_id = "tp4-cd"
  repo       = "Khagou/TP4-CD-githubaction" 
}

resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = local.project_id
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub pool"
  description               = "Identity pool for GitHub deployments"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = local.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_project_service" "ressource_manager" {
  project = local.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "iam" {
  project = local.project_id
  service = "iam.googleapis.com"

  disable_dependent_services = true
}


resource "google_service_account" "github_actions" {
  project      = local.project_id
  account_id   = "github-actions"
  display_name = "Service Account used for GitHub Actions"
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${local.repo}"
}

resource "google_project_iam_binding" "github_editeur" {
  project            = local.project_id
  role               = "roles/editor"

  members = [
    "serviceAccount:${google_service_account.github_actions.email}",
  ]
}
