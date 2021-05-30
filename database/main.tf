resource "google_sql_database_instance" "instance" {
  name             = "${var.database_name}-${random_uuid.instance_id.result}"
  database_version = "POSTGRES_13"
  region           = var.region

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = var.tier
  }
}

resource "random_uuid" "instance_id" {
}
