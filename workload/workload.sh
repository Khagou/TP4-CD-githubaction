#!/bin/bash
export PROJET=tp4-cd-400812 # Change me

gcloud config set project $PROJET

gcloud services enable cloudresourcemanager.googleapis.com --project=$PROJET
gcloud services enable artifactregistry.googleapis.com --project=$PROJET
gcloud services enable compute.googleapis.com --project=$PROJET
gcloud services enable iam.googleapis.com --project=$PROJET
gcloud storage buckets create gs://tp4-tfstate --project=$PROJET


if [ ! -d "workload" ]; then
    echo "Importez le dossier workload"
else
    cd workload
fi
terraform init

# 8- Application de la création avec Terraform
terraform apply -auto-approve