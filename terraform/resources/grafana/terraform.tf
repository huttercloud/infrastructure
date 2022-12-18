terraform {
  cloud {
    organization = "hutter-cloud"

    workspaces {
      name = "grafana"
    }
  }

  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "1.32.0"
    }
  }
}
