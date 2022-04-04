output "docker_registry" {
  value = google_artifact_registry_repository.docker_registry
}

output "service_account" {
  value = module.service_account.service_account
}
