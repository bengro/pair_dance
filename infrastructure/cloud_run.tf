resource "google_project_service" "run_api" {
  service = "run.googleapis.com"

  disable_on_destroy = true
}

resource "google_cloud_run_service" "run_service" {
  name     = "pair-dance-app"
  location = var.gcp_main_region

  template {
    spec {
      containers {
        image = "eu.gcr.io/pair-dance-370619/pair_dance:latest"

        env {
          name = "PHX_HOST"
          value = "pair.dance"
        }

        env {
          name = "POOL_SIZE"
          value = "5"
        }

        env {
          name = "PHOENIX_SESSION_SIGNING_SALT"
          value_from {
            secret_key_ref {
              key  = data.google_secret_manager_secret_version.phoenix_salt.version
              name = data.google_secret_manager_secret_version.phoenix_salt.secret
            }
          }
        }

        env {
          name = "LIVE_VIEW_SIGNING_SALT"
          value_from {
            secret_key_ref {
              key  = data.google_secret_manager_secret_version.live_view_salt.version
              name = data.google_secret_manager_secret_version.live_view_salt.secret
            }
          }
        }

        env {
          name = "DATABASE_URL"
          value_from {
            secret_key_ref {
              key  = data.google_secret_manager_secret_version.database_url.version
              name = data.google_secret_manager_secret_version.database_url.secret
            }
          }
        }

        env {
          name = "GOOGLE_CLIENT_ID"
          value_from {
            secret_key_ref {
              key  = data.google_secret_manager_secret_version.google_client_id.version
              name = data.google_secret_manager_secret_version.google_client_id.secret
            }
          }
        }

        env {
          name = "GOOGLE_CLIENT_SECRET"
          value_from {
            secret_key_ref {
              key  = data.google_secret_manager_secret_version.google_client_secret.version
              name = data.google_secret_manager_secret_version.google_client_secret.secret
            }
          }
        }

        env {
          name = "SECRET_KEY_BASE"
          value_from {
            secret_key_ref {
              key  = data.google_secret_manager_secret_version.secret_key_base.version
              name = data.google_secret_manager_secret_version.secret_key_base.secret
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run_api]
}

resource "google_cloud_run_service_iam_member" "run_all_users" {
  service  = google_cloud_run_service.run_service.name
  location = google_cloud_run_service.run_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_service_account" "app_cloud_run_user" {
  project      = var.gcp_project_id
  account_id   = "cloud-run-user"
  display_name = "Service account to deploy the app on cloud run, has database access"
}

resource "google_project_iam_binding" "sql_access" {
  project = var.gcp_project_id
  role    = "roles/cloudsql.client"
  members = [
    "serviceAccount:${google_service_account.app_cloud_run_user.email}"
  ]
}

data "google_secret_manager_secret_version" "phoenix_salt" {
  secret  = "PRODUCTION_PHOENIX_SESSION_SIGNING_SALT"
  version = "latest"
}

data "google_secret_manager_secret_version" "live_view_salt" {
  secret  = "PRODUCTION_LIVE_VIEW_SIGNING_SALT"
  version = "latest"
}

data "google_secret_manager_secret_version" "database_url" {
  secret  = "PRODUCTION_DATABASE_URL"
  version = "latest"
}

data "google_secret_manager_secret_version" "google_client_secret" {
  secret  = "LOCAL_GOOGLE_CLIENT_SECRET"
  version = "latest"
}

data "google_secret_manager_secret_version" "google_client_id" {
  secret  = "LOCAL_GOOGLE_CLIENT_ID"
  version = "latest"
}

data "google_secret_manager_secret_version" "secret_key_base" {
  secret  = "PRODUCTION_SECRET_KEY_BASE"
  version = "latest"
}

output "service_url" {
  value = google_cloud_run_service.run_service.status[0].url
}


resource "google_cloud_run_v2_job" "db_migration_job" {
  name     = "pair-dance-db-migration"
  location = var.gcp_main_region

  template {
    template {
      containers {
        image = "eu.gcr.io/pair-dance-370619/pair_dance:latest"
        command = ["/app/bin/migrate"]

        env {
          name = "POOL_SIZE"
          value = "1"
        }

        env {
          name = "LIVE_VIEW_SIGNING_SALT"
          value_source {
            secret_key_ref {
              secret = data.google_secret_manager_secret_version.live_view_salt.secret
              version  = data.google_secret_manager_secret_version.live_view_salt.version
            }
          }
        }

        env {
          name = "DATABASE_URL"
          value_source {
            secret_key_ref {
              secret = data.google_secret_manager_secret_version.database_url.secret
              version  = data.google_secret_manager_secret_version.database_url.version
            }
          }
        }

        env {
          name = "SECRET_KEY_BASE"
          value_source {
            secret_key_ref {
              secret = data.google_secret_manager_secret_version.secret_key_base.secret
              version  = data.google_secret_manager_secret_version.secret_key_base.version
            }
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}

resource "google_cloud_run_domain_mapping" "default" {
  name     = "pair.dance"
  location = google_cloud_run_service.run_service.location
  metadata {
    namespace = var.gcp_project_id
  }
  spec {
    route_name = google_cloud_run_service.run_service.name
  }
}
