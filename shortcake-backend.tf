module "network" {
  source = "./modules/network"

  network_name = local.deployment_name
}

module "docker_registry" {
  source = "./modules/docker_registry"

  region        = local.region
  repository_id = local.deployment_name
}

module "cloud_run" {
  source = "./modules/cloud_run"

  service_name = local.deployment_name
  region       = local.region
  image        = "us-docker.pkg.dev/cloudrun/container/hello"

  sql_instance = module.database.database
}

module "database" {
  source = "./modules/database"

  region = local.region
  vpc    = module.network.vpc

  database_name = local.deployment_name
  tier          = "db-f1-micro"

  deletion_protection = (var.release_type == "prod")

  depends_on = [module.network]
}
