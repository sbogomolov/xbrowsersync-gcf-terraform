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

    options {
      machine_type = "UNSPECIFIED"
    }
  }

  depends_on = [
    google_project_service.service,
    google_project_iam_member.cloud_builder,
  ]
}
