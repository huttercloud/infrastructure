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