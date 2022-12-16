terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "pi-hole"
    }
  }

  required_providers {
    pihole = {
      source = "ryanwholey/pihole"
      version = "0.0.12"
    }
  }
}