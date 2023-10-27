provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "gke_cluster" {
    source = "./gke_cluster"
    cluster_name = var.cluster_name
    node_pool_name = var.node_pool_name
    gcp_region = var.gcp_region
    gcp_zone = var.gcp_zone 
    gcp_project = var.gcp_project
    sa_email = var.sa_email
}