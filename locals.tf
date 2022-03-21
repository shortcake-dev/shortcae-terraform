locals {
  project_name = "shortcake"

  project_id = {
    dev     = "${local.project_name}-dev"
    staging = "${local.project_name}-staging-322119"
    prod    = "${local.project_name}-prod"
  }[var.release_type]

  deployment_name = join(
    "-",
    [local.project_name, var.release_type, var.deployment_name]
  )

  region = "us-west1"

  ghcr_repo = "shortcake-dev"
}
