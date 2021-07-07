resource "google_sql_database_instance" "instance" {
  name             = "${var.database_name}-${random_uuid.instance_id.result}"
  database_version = "POSTGRES_13"
  region           = var.region

  deletion_protection = var.deletion_protection

  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc.id
    }
  }
}

resource "random_uuid" "instance_id" {
}
