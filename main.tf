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
    "cloudbuild.googleapis.com",
  ])
  service = each.key

  disable_dependent_services = true
}

resource "google_cloudfunctions_function" "info" {
  name    = "info"
  runtime = "python39"
  region  = "us-central1" # Currently can be only "us-central1"

  available_memory_mb = 128
  trigger_http        = true
  entry_point         = "info"

  source_repository {
    url = "https://source.developers.google.com/projects/${var.project_id}/repos/${var.repository_name}/moveable-aliases/master/paths/"
  }

  depends_on = [google_project_service.service]
}
