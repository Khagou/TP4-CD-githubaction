variable "cluster_name" {
    description = "Cluster name"
}
variable "gcp_project" {
  description = "The GCP project to deploy the runner into."
}
variable "gcp_region" {
  description = "Region name"
}

variable "gcp_zone" {
  description = "Zone name"
}

variable "node_pool_name" {
  description = "node pool name"
}

variable "sa_email" {
  description = "service account email"
}