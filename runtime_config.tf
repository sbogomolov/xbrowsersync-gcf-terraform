resource "google_runtimeconfig_config" "runtime_config" {
  name        = var.runtime_config_name
  description = "Runtime configuration values for cloud functions"

  depends_on = [google_project_service.services]
}

resource "google_runtimeconfig_variable" "accept_new_syncs" {
  parent = google_runtimeconfig_config.runtime_config.name
  name   = "accept_new_syncs"
  text   = var.accept_new_syncs

  lifecycle {
    ignore_changes = [text]
  }
}
