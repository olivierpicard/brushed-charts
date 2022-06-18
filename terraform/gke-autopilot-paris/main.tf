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