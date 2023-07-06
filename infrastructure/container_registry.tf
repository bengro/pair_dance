resource "google_container_registry" "pair_dance_registry" {
  project  = var.gcp_project_id
  location = "EU"
}

resource "google_service_account" "container_registry_user" {
  project      = var.gcp_project_id
  account_id   = "container-registry-user"
  display_name = "Container registry read/write"
}

resource "google_service_account_key" "container_registry_key" {
  service_account_id = google_service_account.container_registry_user.name
}

resource "google_project_iam_binding" "push_images" {
  project = var.gcp_project_id
  role    = "roles/artifactregistry.writer"
  members = [
    "serviceAccount:${google_service_account.container_registry_user.email}"
  ]
}

output "registry_service_account_private_key" {
  sensitive = true
  value     = google_service_account_key.container_registry_key.private_key
}

output "registry_service_account_public_key" {
  value = google_service_account_key.container_registry_key.public_key
}

output "registry_service_account_id" {
  value = google_service_account_key.container_registry_key.id
}
