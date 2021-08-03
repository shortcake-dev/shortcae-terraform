variable "project_id" {
  type = string
  default = "shortcake"
}

variable "release_type" {
  type = string
  default = "dev"
}

variable "deployment_name" {
  description = "Auxiliary suffix to append to release for resource names"
  type = string
  default = null
}

variable "region" {
  type = string
  default = "us-west1"
}
