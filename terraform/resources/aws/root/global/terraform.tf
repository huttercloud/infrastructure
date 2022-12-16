terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "aws-root-global"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.46.0"
    }
  }
}
