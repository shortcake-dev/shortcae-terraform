module "network" {
  source = "./modules/network"

  network_name = local.deployment_name
}

module "docker_registry" {
  source = "./modules/docker_registry"

  project = local.project_id
  deployment_name = var.deployment_name

  region        = local.region
  repository_id = local.deployment_name
}

module "docker_image" {
  source = "./modules/docker_image"

  project = local.project_id
  docker_registry_service_account = module.docker_registry.service_account

  ghcr_repo = local.ghcr_repo

  docker_registry = module.docker_registry.docker_registry
  image_name      = local.project_name
  image_tag       = var.backend_version
}

#module "cloud_run" {
#  source = "./modules/cloud_run"
#
#  service_name = local.deployment_name
#  region       = local.region
#  image        = module.docker_image.image
#
#  sql_instance = module.database.database
#}

module "database" {
  source = "./modules/database"

  region = local.region
  vpc    = module.network.vpc

  database_name = local.deployment_name
  tier          = "db-f1-micro"

  deletion_protection = (var.release_type == "prod")

  depends_on = [module.network]
}
