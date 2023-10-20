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
  default = "terraform@tp4-cd-400812.iam.gserviceaccount.com"
}

variable "subnetwork" {
  description = "Subnetwork name"
  default = "my-subnetwork"
}

variable "private_key" {
  description = "SA private key"
  default = "/home/runner/work/TP4-CD-githubaction/TP4-CD-githubaction/test_env/tf_key"
}

variable "pub_key" {
  description = "SA pub key"
  default = "/home/runner/work/TP4-CD-githubaction/TP4-CD-githubaction/test_env/ssh_keys"
}
variable "user" {
  description = "Service Account email"
  default = "khagu8686"
}