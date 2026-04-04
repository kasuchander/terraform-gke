terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
provider "google" {
    project = "github-action-testing"
    region  =  "us-central1"
}

resource "google_compute_network" "vpc_network" {
    name                    = "my-vpc-network"
    auto_create_subnetworks =  false
}

resource "google_compute_subnetwork" "subnet" {
    name          = "my-subnet"
    ip_cidr_range = "10.0.1.0/24"
    region        =  "us-central1"
    network       = google_compute_network.vpc_network.name
}


resource "google_container_cluster" "primary" {
    name     = "my-gke-cluster"
    location = var.region

    initial_node_count = 1

    node_config {
        machine_type = "e2-medium"
        disk_size_gb = 50
        disk_type = "pd-standard"
    }
}

variable "region" {
   type  =  string
   default =  "us-central1"
}
