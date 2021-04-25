resource "google_project_service" "services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "appengine.googleapis.com",
    "runtimeconfig.googleapis.com",
    "firestore.googleapis.com",
  ])
  service = each.key

  disable_dependent_services = true
  disable_on_destroy         = false
}
