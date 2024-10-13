data "google_project" "project" {
}
resource "google_container_cluster" "create_cluster" {
  name               = var.cluster_name
  location           = var.zone
  initial_node_count = 1
  node_locations = [var.zone2]
  deletion_protection = false
  workload_identity_config {workload_pool = "${data.google_project.project.project_id}.svc.id.goog"}
  secret_manager_config{enabled = true}
  cluster_autoscaling { 
    autoscaling_profile = "OPTIMIZE_UTILIZATION" 
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 12
      maximum = 24
    }
    resource_limits {
      resource_type = "memory"
      minimum = 24
      maximum = 64
    }
  }
  logging_config {enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER"]}
  remove_default_node_pool = true
  addons_config {
    http_load_balancing{disabled = false}
    horizontal_pod_autoscaling{disabled = false}
    network_policy_config {disabled = false}
    cloudrun_config {disabled = true}
  }
  monitoring_config{
    enable_components = []
    managed_prometheus {
      enabled = false
    }
  }
}
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.create_cluster.name
  node_count = 3
  node_config {
    disk_size_gb = 20
    disk_type    = "pd-standard"
    machine_type = "e2-large"

    # Add workload identity service account
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}