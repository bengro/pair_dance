resource "google_project_service" "dns_api" {
  service = "dns.googleapis.com"

  disable_on_destroy = true
}

resource "google_dns_managed_zone" "pair_dance_app" {
  name        = "pair-dance-app"
  project     = var.gcp_project_id
  dns_name    = "pair.dance."
  description = "Pair Dance DNS zone"

  dnssec_config {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "on"

    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 2048
      key_type   = "keySigning"
      kind       = "dns#dnsKeySpec"
    }
    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 1024
      key_type   = "zoneSigning"
      kind       = "dns#dnsKeySpec"
    }
  }
}

resource "google_dns_record_set" "pair-dance-ns" {
  project      = var.gcp_project_id
  managed_zone = google_dns_managed_zone.pair_dance_app.name
  name         = "pair.dance."
  type         = "NS"
  rrdatas      = ["ns-cloud-b1.googledomains.com.", "ns-cloud-b2.googledomains.com.", "ns-cloud-b3.googledomains.com.", "ns-cloud-b4.googledomains.com."]
  ttl          = 3600
}

resource "google_dns_record_set" "cloud_run_a_records" {
  project      = var.gcp_project_id
  managed_zone = google_dns_managed_zone.pair_dance_app.name
  name         = "pair.dance."
  type         = "A"
  rrdatas      = ["216.239.32.21", "216.239.34.21", "216.239.36.21", "216.239.38.21"]
  ttl          = 300
}

resource "google_dns_record_set" "cloud_run_aaaa_records" {
  project      = var.gcp_project_id
  managed_zone = google_dns_managed_zone.pair_dance_app.name
  name         = "pair.dance."
  type         = "AAAA"
  rrdatas      = ["2001:4860:4802:32::15", "2001:4860:4802:34::15", "2001:4860:4802:36::15", "2001:4860:4802:38::15"]
  ttl          = 300
}
