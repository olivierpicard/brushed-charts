data "google_client_config" "provider" {}

data "google_container_cluster" "gke_autopilot_paris" {
  name     = "gke-autopilot-paris"
  location = "europe-west9"
}

output "endpoint" {
  value = data.google_container_cluster.gke_autopilot_paris.endpoint
}

module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id           = "brushed-charts"
  cluster_name         = "gke-autopilot-paris"
  location             = "europe-west9"
}


provider "helm" {
    provider "kubernetes" {
        host  = "https://${data.google_container_cluster.gke_autopilot_paris.endpoint}"
        token = data.google_client_config.provider.access_token
        cluster_ca_certificate = base64decode(
            data.google_container_cluster.gke_autopilot_paris.master_auth[0].cluster_ca_certificate,
        )
    }
}



