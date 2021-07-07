resource "google_project_service" "artifact_registry_services" {
  for_each = toset([
    "artifactregistry.googleapis.com",
  ])

  service = each.key
}

resource "google_artifact_registry_repository" "docker_registry" {
  provider = google-beta

  location      = var.region
  repository_id = var.repository_id
  format        = "DOCKER"

  depends_on = [google_project_service.artifact_registry_services]
}
