provider "google" {
  region  = var.region
  zone    = var.zone
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

resource "google_project" "project" {
  name       = var.project_name
  project_id = random_id.id.hex
}

output "project_id" {
  value = google_project.project.project_id
}
