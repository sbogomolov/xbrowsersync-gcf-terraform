provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "sourcerepo" {
  service                    = "sourcerepo.googleapis.com"
  disable_dependent_services = true
}

resource "google_sourcerepo_repository" "x-browser-sync-gcf" {
  name = var.repository_name

  depends_on = [google_project_service.sourcerepo]
}

# resource "google_cloudfunctions_function" "function" {
#   name        = "function-test"
#   description = "My function"
#   runtime     = "python39"

#   available_memory_mb = 128
#   trigger_http        = true
#   entry_point         = "helloGET"
# }
