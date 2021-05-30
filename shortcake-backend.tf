module "docker_registry" {
  source = "./docker_registry"

  region = var.region
  repository_id = "${var.project_id}-backend"
}

module "cloud_run" {
  source = "./cloud_run"

  service_name = "${var.project_id}-backend"
  region = var.region
  image = "us-docker.pkg.dev/cloudrun/container/hello"
}

module "database" {
  source = "./database"

  region = var.region

  database_name = "${var.project_id}-backend"
  tier = "db-f1-micro"
}
