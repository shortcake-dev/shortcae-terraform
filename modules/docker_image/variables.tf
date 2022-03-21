variable "project" {
  type = string
}

variable "ghcr_repo" {
  type = string
}

variable "docker_registry" {
  type = object({
    location      = string
    name          = string
    repository_id = string  # TODO: Use just name/id?
  })
}

variable "image_name" {
  type = string
}

variable "image_tag" {
  type = string
}
