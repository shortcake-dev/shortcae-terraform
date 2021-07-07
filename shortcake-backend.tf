locals {
  service_name = "${var.project_id}-backend"
}

module "network" {
  source = "./modules/network"

  network_name = local.service_name
}

module "docker_registry" {
  source = "./modules/docker_registry"

  region = var.region
  repository_id = local.service_name
}

module "cloud_run" {
  source = "./modules/cloud_run"

  service_name = local.service_name
  region = var.region
  image = "us-docker.pkg.dev/cloudrun/container/hello"

  sql_instance = module.database.database
}

module "database" {
  source = "./modules/database"

  region = var.region
  vpc = module.network.vpc

  database_name = local.service_name
  tier = "db-f1-micro"

  deletion_protection = (var.release_type == "prod")

  depends_on = [module.network]
}
