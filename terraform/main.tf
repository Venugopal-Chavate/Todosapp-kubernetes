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

  force_destroy               = false
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
  project_number     = var.project_number
  project_id         = var.project_id
}

##############secret manager############################
resource "google_secret_manager_secret" "my_secret_1" {
  secret_id = "username"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret" "my_secret_2" {
  secret_id = "password"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret" "my_secret_3" {
  secret_id = "uri"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
##############secret manager############################
#iam for accessing secrets
resource "google_project_iam_member" "readsecrets" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/default/sa/readonly-sa"

}