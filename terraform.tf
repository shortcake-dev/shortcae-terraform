terraform {
  backend "remote" {
    organization = "shortcake"

    workspaces {
      prefix = "shortcake-"
    }
  }
}
