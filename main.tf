provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_project" "project" {
}

resource "google_project_service" "service" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "appengine.googleapis.com",
    "runtimeconfig.googleapis.com",
  ])
  service = each.key

  disable_dependent_services = true
}

resource "google_app_engine_application" "firestore" {
  project       = var.project_id
  location_id   = var.location_id
  database_type = "CLOUD_FIRESTORE"

  depends_on = [google_project_service.service]
}

resource "google_runtimeconfig_config" "runtime_config" {
  name        = var.runtime_config_name
  description = "Runtime configuration values for cloud functions"

  depends_on = [google_project_service.service]
}

resource "google_runtimeconfig_variable" "accept_new_syncs" {
  parent = google_runtimeconfig_config.runtime_config.name
  name   = "accept_new_syncs"
  text   = var.accept_new_syncs
}

resource "google_cloudfunctions_function" "function" {
  for_each = { for f in var.functions : f.name => f.entry_point }

  name    = each.key
  runtime = "python39"

  available_memory_mb = 128
  max_instances       = 1
  timeout             = 10
  trigger_http        = true
  entry_point         = each.value

  source_repository {
    url = "https://source.developers.google.com/projects/${var.project_id}/repos/${var.repository_name}/moveable-aliases/master/"
  }

  environment_variables = {
    RUNTIME_CONFIG_NAME = google_runtimeconfig_config.runtime_config.name
  }

  lifecycle {
    ignore_changes = [
      labels,
      source_repository,
    ]
  }

  depends_on = [
    google_project_service.service,
    google_app_engine_application.firestore,
  ]
}

resource "google_cloudfunctions_function_iam_member" "function_invoker" {
  for_each = { for f in google_cloudfunctions_function.function : f.name => f }

  project        = each.value.project
  region         = each.value.region
  cloud_function = each.key

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_project_iam_member" "cloud_builder" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/cloudfunctions.developer",
  ])
  role   = each.key
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project_service.service]
}

resource "google_cloudbuild_trigger" "deploy_trigger" {
  name = var.deploy_trigger_name

  trigger_template {
    branch_name = "master"
    repo_name   = var.repository_name
  }

  build {
    dynamic "step" {
      for_each = google_cloudfunctions_function.function

      content {
        name = "gcr.io/cloud-builders/gcloud"
        args = [
          "functions",
          "deploy",
          step.value.name,
          "--source=.",
          "--trigger-http",
          "--security-level=secure-always",
          "--runtime=python39",
          "--entry-point=${step.value.entry_point}",
        ]
        timeout = "300s"
      }
    }
  }

  depends_on = [
    google_project_service.service,
    google_project_iam_member.cloud_builder,
  ]
}
