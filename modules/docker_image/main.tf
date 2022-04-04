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

  ghcr_registry = "ghcr.io/${var.ghcr_repo}"
}

data "google_service_account_access_token" "artifact_registry_image_sa_token" {
  target_service_account = var.docker_registry_service_account.email
  scopes                 = ["cloud-platform"]
}

provider "docker" {
  registry_auth {
    address  = local.google_domain
    username = "oauth2accesstoken"
    password = data.google_service_account_access_token.artifact_registry_image_sa_token.access_token
  }
}

data "docker_registry_image" "ghcr_image_pull" {
  name = "${local.ghcr_registry}/${local.complete_image_name}"
}

resource "docker_image" "ghcr_image" {
  name          = data.docker_registry_image.ghcr_image_pull.name
  pull_triggers = [data.docker_registry_image.ghcr_image_pull.sha256_digest]
}

# https://github.com/kreuzwerker/terraform-provider-docker/issues/137
resource "null_resource" "gar_image_push_tag" {
  triggers = {
    sha256 = data.docker_registry_image.ghcr_image_pull.sha256_digest
    gar_image = "${local.google_registry}/${local.complete_image_name}"
  }
  provisioner "local-exec" {
    command = <<-EOT
      docker tag ${docker_image.ghcr_image.name} ${self.triggers.gar_image}
    EOT
  }
}

resource "docker_registry_image" "gar_image_push" {
  name = null_resource.gar_image_push_tag.triggers.gar_image
}
