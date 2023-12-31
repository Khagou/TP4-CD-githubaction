variable "gcp_project" {
  type        = string
  default     = "tp4-test-405014" # Change me
  description = "The GCP project to deploy the runner into."
}
variable "gcp_zone" {
  type        = string
  default     = "europe-west1-c" # Change me if you need
  description = "The GCP zone to deploy the runner into."
}

variable "gcp_region" {
  type        = string
  default     = "europe-west1" # Change me if you need
  description = "The GCP region to deploy the runner into."
}

##########################################
# Instances variables
##########################################

variable "test" {
  description = "Instance dev app python"
  default = "python-test-instance" # Change me if you need
}

variable "machine" {
  description = "Machine type"
  default = "e2-medium" # Change me if you need
}

variable "sa_email" {
  description = "Service Account email"
  default = "terraform@tp4-test-405014.iam.gserviceaccount.com"
}

variable "subnetwork" {
  description = "Subnetwork name"
  default = "my-subnetwork"
}

variable "user" {
  description = "SSH user"
  default = "runner"
}