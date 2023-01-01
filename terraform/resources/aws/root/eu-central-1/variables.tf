variable "pi_hole_webpassword" {
  sensitive = true
  type      = string
}

variable "oauth2_proxy_cookie_secret" {
  sensitive = true
  type      = string
}

variable "synology_certificate_private_key" {
  sensitive = true
  type      = string
}
variable "grafana_cloud_metrics_publisher" {
  sensitive = true
  type      = string
}

# argo cd declarative setup
variable "argo_cd_declarative_kubernetes_host_node_a" {
  sensitive = true
  type      = string
}

variable "argo_cd_declarative_kubernetes_token_node_a" {
  sensitive = true
  type      = string
}

variable "argo_cd_declarative_kubernetes_cluster_ca_cert_data_node_a" {
  sensitive = true
  type      = string
}


variable "argo_cd_declarative_kubernetes_host_node_b" {
  sensitive = true
  type      = string
}

variable "argo_cd_declarative_kubernetes_token_node_b" {
  sensitive = true
  type      = string
}

variable "argo_cd_declarative_kubernetes_cluster_ca_cert_data_node_b" {
  sensitive = true
  type      = string
}

variable "argo_cd_declarative_github_applications_deploy_key" {
  sensitive = true
  type      = string
}

variable "grafana_admin_password" {
  sensitive = true
  type      = string
}

variable "loki_gateway_credentials" {
  sensitive = true
  type      = string
}
