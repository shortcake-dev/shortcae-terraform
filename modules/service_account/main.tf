resource "random_uuid" "account_id" {
}

resource "google_service_account" "service_account" {
  account_id   = "sa-${random_uuid.account_id.result}"
  display_name = "${var.name}-${var.deployment_name}"
}

resource "google_project_iam_member" "service_account_iam_member" {
  for_each = var.roles

  project = var.project
  role = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
