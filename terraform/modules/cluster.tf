resource "google_container_cluster" "create_cluster" {
  name               = var.cluster_name
  location           = var.zone
  initial_node_count = 3
  node_locations = [var.zone2]
}
