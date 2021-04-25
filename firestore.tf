resource "google_app_engine_application" "firestore" {
  project       = var.project_id
  location_id   = var.location_id
  database_type = "CLOUD_FIRESTORE"

  depends_on = [google_project_service.service]
}
