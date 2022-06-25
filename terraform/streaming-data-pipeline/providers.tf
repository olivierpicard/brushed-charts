terraform {
  cloud {
    organization = "brushed-charts"

    workspaces {
      name = "streaming-data-pipeline"
    }
  }
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.76.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.23.0"
    }
    local = {
      version = "~> 2.1"
    }
  }
}

provider "oci" {
  user_ocid    = "ocid1.user.oc1..aaaaaaaayri56mue6kr4awvywuq5kz6ws4hk5mn3etenkn6gexh3ax3xdsnq"
  tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaagomus4uwllivbv3rpzgnwebsp7ynanjnuuulbfgb5xqdihbnggyq"
  private_key  = var.oci_private_key
  fingerprint  = "66:69:94:2f:fe:d8:f9:97:3f:c8:bf:35:e4:0a:5d:68"
  region       = "eu-marseille-1"
}

provider "google" {
  project = "brushed-charts"
  region  = "europe-west9"
}