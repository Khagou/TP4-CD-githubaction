#!/bin/bash
export PROJET=tp4-cd-400812 # Change me

gcloud config set project $PROJET

gcloud services enable cloudresourcemanager.googleapis.com --project=$PROJET
gcloud services enable artifactregistry.googleapis.com --project=$PROJET
gcloud services enable compute.googleapis.com --project=$PROJET
gcloud services enable iam.googleapis.com --project=$PROJET
gcloud services enable containerregistry.googleapis.com --project=$PROJET
gcloud storage buckets create gs://tp4-tfstate --project=$PROJET
gcloud services enable container.googleapis.com

terraform init

# 8- Application de la création avec Terraform
terraform apply -auto-approve