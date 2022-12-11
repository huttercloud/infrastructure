terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "node-a"
    }
  }

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.7.1"
    }
  }
}