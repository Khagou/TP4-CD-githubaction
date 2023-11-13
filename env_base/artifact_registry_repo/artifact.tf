# artifact_registry_repo / artifact.tf
resource "google_artifact_registry_repository" "docker-repo" {
  location      = var.gcp_region
  repository_id = var.docker-repo
  description   = "docker repository"
  format        = "DOCKER"
}