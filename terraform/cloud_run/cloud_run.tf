resource "google_cloud_run_service" "dev-env" {
  name     = "dev-env"
  location = var.gcp_region

  template {
    spec {
      containers {
        image = "europe-west1-docker.pkg.dev/tp4-cd-400812/docker-repo/tp4-cd"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}