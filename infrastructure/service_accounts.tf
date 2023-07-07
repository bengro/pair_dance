resource "google_project_iam_binding" "service-account" {
  project = var.gcp_project_id

  for_each = toset([
    "roles/storage.admin",
    "roles/run.admin",
  ])
  role = each.key

  members = [
    "serviceAccount:${google_service_account.container_registry_user.email}"
  ]
}
