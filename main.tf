provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "service" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudfunctions.googleapis.com",
  ])
  service = each.key

  disable_dependent_services = true
}

# resource "google_sourcerepo_repository" "repository" {
#   name = var.repository_name

#   depends_on = [google_project_service.service]
# }

# resource "google_cloudfunctions_function" "info" {
#   name    = "info"
#   runtime = "python39"
#   region  = "us-central1" # Currently can be only "us-central1"

#   available_memory_mb = 128
#   trigger_http        = true
#   entry_point         = "info"

#   source_repository {
#     url = google_sourcerepo_repository.repository.url
#   }

#   depends_on = [
#     google_project_service.service,
#     google_sourcerepo_repository.repository,
#   ]
# }
