output "vpc" {
  value = google_compute_network.vpc
}

output "vpc_connection" {
  value = google_service_networking_connection.vpc_connection
}
