# k8s connection vars, not using env vars as the base64 encoded ca cert needs
# encoding.
variable "kubernetes_host" {
  type = string
}

variable "kubernetes_token" {
  type = string
}

variable "kubernetes_cluster_ca_cert_data" {
  type = string
}

# argo cd secrets for helm charts
# not all helm values support secret references so instead
# of mixing the base configuration up every secret is either
# passed as data source (for auth0) or as variable to this
# resource
variable "argo_cd_server_admin_password" {
  type = string
  sensitive = true
} 