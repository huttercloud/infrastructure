locals {
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_ca_cert_data)
}

provider "kubernetes" {
  host                   = var.kubernetes_host
  token                  = var.kubernetes_token
  cluster_ca_certificate = local.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes_host
    token                  = var.kubernetes_token
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}
