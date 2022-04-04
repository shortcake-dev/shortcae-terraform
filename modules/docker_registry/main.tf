module "service_account" {
  source = "../service_account"

  project = var.project
  deployment_name = var.deployment_name

  name = "artifact-registry"
  roles = [
    "roles/artifactregistry.repoAdmin"
  ]
}

resource "google_artifact_registry_repository" "docker_registry" {
  provider = google-beta

  location      = var.region
  repository_id = var.repository_id
  format        = "DOCKER"
}
