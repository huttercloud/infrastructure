terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "node-b"
    }
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
  }
}

# external datasource containing auth0 
data "terraform_remote_state" "auth0" {
  backend = "remote"

  config = {
    organization = "hutter-cloud"
    workspaces = {
      name = "auth0"
    }
  }
}
data "terraform_remote_state" "aws-root-global" {
  backend = "remote"

  config = {
    organization = "hutter-cloud"
    workspaces = {
      name = "aws-root-global"
    }
  }
}

data "terraform_remote_state" "grafana" {
  backend = "remote"

  config = {
    organization = "hutter-cloud"
    workspaces = {
      name = "grafana"
    }
  }
}