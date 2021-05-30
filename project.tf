provider "google" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region
}
