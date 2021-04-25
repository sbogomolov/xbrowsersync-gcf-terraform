resource "google_cloudfunctions_function" "functions" {
  for_each = { for f in var.functions : f.name => f.entry_point }

  name    = each.key
  runtime = "python39"

  available_memory_mb = 128
  max_instances       = 1
  timeout             = 10
  trigger_http        = true
  entry_point         = each.value

  source_repository {
    url = "https://source.developers.google.com/projects/${var.project_id}/repos/${var.repository_name}/moveable-aliases/master"
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
    google_project_service.services,
    google_app_engine_application.firestore,
  ]
}

resource "google_cloudfunctions_function_iam_member" "function_invokers" {
  for_each = { for f in google_cloudfunctions_function.functions : f.name => f }

  project        = each.value.project
  region         = each.value.region
  cloud_function = each.key

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
