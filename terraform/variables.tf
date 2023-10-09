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
# Artifact registry repo variables
#########################################
variable "docker-repo" {
  description = "Repo name."
  default = "docker-repo" # Change me if you need
}


##########################################
# Instances variables
##########################################
variable "dev" {
  description = "Instance dev app python"
  default = "python-dev-instance" # Change me if you need
}
variable "test" {
  description = "Instance dev app python"
  default = "python-dev-instance" # Change me if you need
}

variable "machine" {
  description = "Machine type"
  default = "e2-medium" # Change me if you need
}


#########################################
# Service account variables
#########################################
variable "ansible_account_id" {
  description = "Service account id."
  default = "ansible" # Change me if you need
}

variable "ansible_display_name" {
  description = "Service account name."
  default = "ansible" # Change me if you need
}

variable "ansible_key_filename" {
  description = "How to deploy the key and how to name it."
  default = "../ansible/ansible_service_account.json" # Change me if you need
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


#########################################
# GKE Cluster variables
#########################################
variable "cluster_name" {
    description = "Cluster name"
    default = "deployment cluster"
}
