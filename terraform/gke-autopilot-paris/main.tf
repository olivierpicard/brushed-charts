terraform {
  cloud {
    organization = "brushed-charts"

    workspaces {
      name = "gke-autopilot-paris"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.23.0"
    }
  }
}


provider "google" {
  project = "brushed-charts"
  region  = "europe-west9"
}


resource "google_container_cluster" "gke_autopilot_paris" {
  name     = "gke-autopilot-paris"
  location = "europe-west9"
  ip_allocation_policy {}
  enable_autopilot = true

  lifecycle {
    prevent_destroy = true
  }
}


output "gke-endpoint" {
  value       = google_container_cluster.gke_autopilot_paris.endpoint
  description = "URL to access to GKE autopilot Paris cluster"
}

output "gke-certificate" {
  value       = google_container_cluster.gke_autopilot_paris.master_auth.0.client_certificate
  description = "Public certificate of GKE autopilot Paris cluster"
}

output "gke-client_key" {
  value       = google_container_cluster.gke_autopilot_paris.master_auth.0.client_key
  description = "Client private key for GKE autopilot Paris cluster"
  sensitive   = true
}

output "gke-cluster_ca_certificate" {
  value       = google_container_cluster.gke_autopilot_paris.master_auth.0.cluster_ca_certificate
  description = "Cluster public CA Certificate for GKE autopilot Paris cluster"
}


