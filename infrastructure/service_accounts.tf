resource "google_service_account" "ci" {
  project      = var.gcp_project_id
  account_id   = "ci-service-account"
  display_name = "Service account with permissions to push images and deploy to cloud run"
}

resource "google_project_iam_binding" "service-account" {
  project = var.gcp_project_id

  for_each = toset([
    "roles/storage.admin",
    "roles/run.admin",
    "roles/iam.serviceAccountUser"
  ])
  role = each.key

  members = [
    "serviceAccount:${google_service_account.ci.email}"
  ]
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.ci.name
}

output "ci_service_account_private_key" {
  sensitive = true
  value     = google_service_account_key.service_account_key.private_key
}

output "ci_service_account_public_key" {
  value = google_service_account_key.service_account_key.public_key
}

output "ci_service_account_id" {
  value = google_service_account_key.service_account_key.id
}
