provider "google" {
  project     = local.project_id
  region      = local.region
}

provider "google-beta" {
  project     = local.project_id
  region      = local.region
}
