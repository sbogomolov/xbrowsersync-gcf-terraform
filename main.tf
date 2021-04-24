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

resource "google_cloudfunctions_function" "function" {
  for_each = toset(var.function_names)

  name    = each.key
  runtime = "python39"

  available_memory_mb = 128
  max_instances       = 1
  timeout             = 10
  trigger_http        = true
  entry_point         = each.key

  source_repository {
    url = "https://source.developers.google.com/projects/${var.project_id}/repos/${var.repository_name}/moveable-aliases/master/paths/"
  }

  depends_on = [google_project_service.service]
}

resource "google_cloudfunctions_function_iam_member" "function_invoker" {
  for_each = toset(var.function_names)

  project        = var.project_id
  region         = var.region
  cloud_function = each.key

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
