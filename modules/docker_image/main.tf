locals {
  complete_image_name = "${var.image_name}:${var.image_tag}"

  google_subdomain = "${var.docker_registry.location}-docker"
  google_registry  = "${local.google_subdomain}.pkg.dev/${var.project}/${var.docker_registry.repository_id}"

  dockerhub_registry = "registry.hub.docker.com/${var.dockerhub_repo}"
}

module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform = "linux"

  create_cmd_entrypoint  = "gcloud"
  create_cmd_body        = "auth configure-docker"
}

resource "null_resource" "docker_image" {
  triggers = {
    # https://github.com/hashicorp/terraform/issues/23679
    dockerhub_image = "${local.dockerhub_registry}/${local.complete_image_name}"
    google_image    = "${local.google_registry}/${local.complete_image_name}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      docker pull ${self.triggers.dockerhub_image}
      docker tag ${self.triggers.dockerhub_image} ${self.triggers.google_image}
      docker push ${self.triggers.google_image}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      docker login
      gcloud artifacts docker images delete ${self.triggers.google_image}
    EOT
  }

  depends_on = [module.gcloud.wait]
}

