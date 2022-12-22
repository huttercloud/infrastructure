terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "auth0"
    }
  }

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "0.40.0"
    }
  }
}
