terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "mikrotik"
    }
  }

  required_providers {
    mikrotik = {
      source  = "ddelnano/mikrotik"
      version = "0.10.0"
    }
  }
}