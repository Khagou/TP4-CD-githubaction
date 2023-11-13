# artifact_registry_repo / variables.tf

variable "gcp_region" {
  description = "The GCP region to deploy the runner into."
}
variable "docker-repo" {
  description = "Repo name."
}