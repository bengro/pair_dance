resource "google_container_registry" "pair_dance_registry" {
  project  = var.gcp_project_id
  location = "EU"
}
