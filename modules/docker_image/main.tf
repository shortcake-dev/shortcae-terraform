terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
  required_version = ">= 0.14"
}

locals {
  complete_image_name = "${var.image_name}:${var.image_tag}"

  google_subdomain = "${var.docker_registry.location}-docker"
  google_domain    = "${local.google_subdomain}.pkg.dev"
  google_registry  = "${local.google_domain}/${var.project}/${var.docker_registry.repository_id}"

  dockerhub_registry = "registry.hub.docker.com/${var.dockerhub_repo}"
}

resource "google_service_account" "artifact_registry_image_sa" {
  account_id   = "terraform-artifact-registry-sa"
  display_name = "terraform-artifact-registry-sa"
}

resource "google_project_iam_member" "artifact_registry_image_sa" {
  project = var.project
  role    = "roles/artifactregistry.repoAdmin"
  member = "serviceAccount:${google_service_account.artifact_registry_image_sa.email}"
}

#data "google_service_account_access_token" "artifact_registry_image_sa_token" {
#  target_service_account = google_service_account.artifact_registry_image_sa.email
#  scopes                 = ["cloud-platform"]
#}
#
#provider "docker" {
#  registry_auth {
#    address  = local.google_domain
#    username = "oauth2accesstoken"
#    password = data.google_service_account_access_token.artifact_registry_image_sa_token.access_token
#  }
#}
