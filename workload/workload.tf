# provider "google" {
#   project     = var.gcp_project
#   region      = var.gcp_region
#   zone        = var.gcp_zone
# }

# resource "google_iam_workload_identity_pool" "github_pool" {
#   project                   = var.gcp_project
#   workload_identity_pool_id = "github-pool"
#   display_name              = "GitHub pool"
#   description               = "Identity pool for GitHub deployments"
# }

# resource "google_iam_workload_identity_pool_provider" "github" {
#   project                            = var.gcp_project
#   workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
#   workload_identity_pool_provider_id = "github-provider"
#   attribute_mapping = {
#     "google.subject"       = "assertion.sub"
#     "attribute.actor"      = "assertion.actor"
#     "attribute.aud"        = "assertion.aud"
#     "attribute.repository" = "assertion.repository"
#   }
#   oidc {
#     issuer_uri = "https://token.actions.githubusercontent.com"
#   }
# }

# resource "google_project_service" "ressource_manager" {
#   project = var.gcp_project
#   service = "cloudresourcemanager.googleapis.com"

#   disable_dependent_services = true
# }

# resource "google_project_service" "iam" {
#   project = var.gcp_project
#   service = "iam.googleapis.com"

#   disable_dependent_services = true
# }



# resource "google_service_account_iam_member" "workload_identity_user" {
#   service_account_id = google_service_account.github_actions.name
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "principalSet://iam.googleapis.com/projects/${var.gcp_project}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${local.repo}"
# }

# resource "google_project_iam_binding" "github_editeur" {
#   project            = var.gcp_project
#   role               = "roles/editor"

#   members = [
#     "serviceAccount:${google_service_account.github_actions.email}",
#   ]
# }

resource "google_service_account" "github-actions" {
  project      = var.gcp_project
  account_id   = "github-actions"
  display_name = "Service Account used for GitHub Actions"
}

resource "google_iam_workload_identity_pool" "main" {
  provider                  = google-beta
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = var.pool_description
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "main" {
  provider                           = google-beta
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = var.provider_display_name
  description                        = var.provider_description
  attribute_condition                = var.attribute_condition
  attribute_mapping                  = var.attribute_mapping
  oidc {
    allowed_audiences = var.allowed_audiences
    issuer_uri        = var.issuer_uri
  }
}

resource "google_service_account_iam_member" "wif-sa" {
  for_each           = var.sa_mapping
  service_account_id = google_service_account.github-actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.main.name}/${each.value.attribute}"
}
resource "google_service_account" "terraform" {
  project      = var.gcp_project
  account_id   = "terraform"
  display_name = "Service Account used for Terraform deployment"
}
resource "google_service_account_iam_binding" "terraform" {
  service_account_id = google_service_account.terraform.name
  role               = "roles/editor"
   members = [
    "serviceAccount:${google_service_account.terraform.email}",
  ]
}