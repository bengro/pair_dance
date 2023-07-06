resource "google_sql_database" "pair_dance" {
  name     = "pair-dance"
  instance = google_sql_database_instance.pair_dance.name
  project  = var.gcp_project_id
}

resource "google_sql_database_instance" "pair_dance" {
  name             = "pair-dance-db"
  database_version = "POSTGRES_13"
  region           = var.gcp_main_region
  project          = var.gcp_project_id

  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"

    backup_configuration {
      enabled = false
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }
  }

  deletion_protection = "false"
}

resource "google_sql_user" "db_user" {
  instance = google_sql_database_instance.pair_dance.name
  name     = "app_user"
  password = data.google_secret_manager_secret_version.db_password.secret_data
  project  = var.gcp_project_id
}

data "google_secret_manager_secret_version" "db_password" {
  secret  = "PRODUCTION_DB_PASSWORD"
  version = "1"
}

output "connection_ip" {
  value = google_sql_database_instance.pair_dance.ip_address
}

output "db_username" {
  value = google_sql_user.db_user.name
}

output "db_password" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.db_password.secret_data
}
