terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "pi-hole"
    }
  }

  required_providers {
    pihole = {
      source  = "ryanwholey/pihole"
      version = "0.0.12"
    }
  }
}

data "terraform_remote_state" "mikrotik" {
  backend = "remote"

  config = {
    organization = "hutter-cloud"
    workspaces = {
      name = "mikrotik"
    }
  }
}
