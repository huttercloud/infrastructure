terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "aws-root-eu-central-1"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0"
    }
  }
}

data "terraform_remote_state" "auth0" {
  backend = "remote"

  config = {
    organization = "hutter-cloud"
    workspaces = {
      name = "auth0"
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

data "terraform_remote_state" "aws-root-global" {
  backend = "remote"

  config = {
    organization = "hutter-cloud"
    workspaces = {
      name = "aws-root-global"
    }
  }
}