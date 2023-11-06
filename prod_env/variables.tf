variable "gcp_project" {
  type        = string
  default     = "tp4-cd-403915" # Change me
  description = "The GCP project to deploy the runner into."
}
variable "gcp_zone" {
  type        = string
  default     = "europe-west1-b" # Change me if you need
  description = "The GCP zone to deploy the runner into."
}

variable "gcp_region" {
  type        = string
  default     = "europe-west1" # Change me if you need
  description = "The GCP region to deploy the runner into."
}

#########################################
# GKE Cluster variables
#########################################
variable "cluster_name" {
    description = "Cluster name"
    default = "deployment-cluster"
}
variable "node_pool_name" {
  description = "node pool name"
  default = "deployment-node-pool"
}

variable "sa_email" {
  description = "service account email"
  default = "terraform@tp4-cd-403915.iam.gserviceaccount.com"
}