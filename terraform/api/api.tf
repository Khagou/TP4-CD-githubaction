resource "google_project_service" "container" {
  project = var.project
  service = "container.googleapis.com"
}

resource "google_project_service" "container_registry" {
  project = var.project
  service = "containerregistry.googleapis.com"
}

resource "google_project_service" "compute" {
  project = var.project
  service = "compute.googleapis.com"
}

resource "google_project_service" "cloud_resource_manager" {
  project = var.project
  service = "cloudresourcemanager.googleapis.com"
}
