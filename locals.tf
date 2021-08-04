locals {
  project_name = "shortcake"

  project_id = {
    dev     = "${local.project_name}-dev"
    staging = "${local.project_name}-staging"
    prod    = "${local.project_name}-prod"
  }[var.release_type]

  deployment_name = join(
    "-",
    compact([local.project_name, var.release_type, var.deployment_name])
  )

  region = "us-west1"
}
