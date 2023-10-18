variable "gcp_project" {
  type        = string
  default     = "tp4-cd-400812" # Change me
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
# Artifact Registry
#########################################
variable "docker-repo" {
  description = "Repo name."
  default = "docker-repo" # Change me if you need
}

#########################################
# Network variables
#########################################
variable "subnet_cidr" {
  description = "CIDR block for the subnetwork."
  default = "10.0.0.0/24" # Change me if you need
}
variable "firewall_source" {
  description = "source block for the firewall."
  default = ["10.0.0.0/24"] # Change me if you need
}