data "google_project" "project" {
}
resource "google_container_cluster" "create_cluster" {
  name               = var.cluster_name
  location           = var.zone
  initial_node_count = 3
  node_locations = [var.zone2]
  workload_identity_config {
      workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
    }
  
  addons_config {
    
    http_load_balancing{
      disabled = false
    }
    horizontal_pod_autoscaling{
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
  }
  node_config {
    disk_size_gb = 20
    disk_type = "pd-standard"  
    machine_type = "e2-medium" 
  }
}
  