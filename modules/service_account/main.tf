resource "google_service_account" "service_account" {
  account_id   = "${var.name}-sa-${var.deployment_name}"
  display_name = var.name
}

resource "google_project_iam_member" "service_account_iam_member" {
  for_each = var.roles

  project = var.project
  role = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
