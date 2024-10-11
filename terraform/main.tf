terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "sonic-arcadia-437913-c5"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-c"
}
##############store state in cloud bucket#############
resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name     = "${random_id.default.hex}-terraform-remote-backend"
  location = "US"

  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.module}/backend.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.default.name}"
    }
  }
  EOT
}
##############store state in cloud bucket#############

module "create_cluster" {
  source = "./modules"
  cluster_name       = var.cluster_name
  zone               = var.zone
  region             = var.region
  zone2              = var.zone_2
  location           = "JAPAN"
}

resource "google_compute_global_address" "argocd_ingress_ip" {
  name = "argocd-ingress-ip"
  address_type = "EXTERNAL"
  ip_version = "IPV4"
}

resource "google_compute_global_address" "todos_ingress_ip" {
  name = "todos-ingress-ip"
  address_type = "EXTERNAL"
  ip_version = "IPV4"
}