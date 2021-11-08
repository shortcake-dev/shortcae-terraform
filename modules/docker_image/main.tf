locals {
  complete_image_name = "${var.image_name}:${var.image_tag}"

  google_subdomain = "${var.docker_registry.location}-docker"
  google_registry  = "${local.google_subdomain}.pkg.dev/${var.project}/${var.docker_registry.repository_id}"

  dockerhub_registry = "registry.hub.docker.com/${var.dockerhub_repo}"
}

resource "null_resource" "docker_image" {
  dockerhub_image = "${local.dockerhub_registry}/${complete_image_name}"
  google_image    = "${local.google_registry}/${complete_image_name}"

  provisioner "local-exec" {
    command = <<-EOT
      docker pull ${self.dockerhub_image}
      docker tag ${self.dockerhub_image} ${self.google_image}
      docker push ${self.google_image}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "gcloud artifacts docker images delete ${self.google_image}"
  }
}

