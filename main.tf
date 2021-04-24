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

data "google_project" "project" {
}

resource "google_project_iam_member" "cloud-builder" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/cloudfunctions.developer",
  ])
  role   = each.key
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project_service.service]
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

  environment_variables = {
    ACCEPT_NEW_SYNCS = var.accept_new_syncs
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

  depends_on = [google_cloudfunctions_function.function]
}
