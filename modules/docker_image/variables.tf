variable "project" {
  type = string
}

variable "dockerhub_repo" {
  type = string
}

variable "docker_registry" {
  type = object({
    location      = string
    repository_id = string
  })
}

variable "image_name" {
  type = string
}

variable "image_tag" {
  type = string
}
