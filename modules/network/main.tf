# Reference:
# https://github.com/gruntwork-io/terraform-google-sql/blob/v0.5.0/examples/postgres-private-ip/main.tf

locals {
  network_name = "${var.network_name}-${random_uuid.network_id.result}"
}

# Simple network, auto-creates subnetworks
resource "google_compute_network" "vpc" {
  name = local.network_name
}

# Reserve global internal address range for the peering
resource "google_compute_global_address" "private_ip_block" {
  network = google_compute_network.vpc.self_link

  name = local.network_name

  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
}

# Establish VPC network peering connection using the reserved address range
resource "google_service_networking_connection" "vpc_connection" {
  network = google_compute_network.vpc.self_link

  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

resource "random_uuid" "network_id" {
}
