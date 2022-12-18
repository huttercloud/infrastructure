variable "pi_hole_webpassword" {
    sensitive = true
    type = string
}

variable "oauth2_proxy_cookie_secret" {
    sensitive = true
    type = string
}

variable "synology_certificate_private_key" {
    sensitive = true
    type = string
}
variable "grafana_cloud_metrics_publisher" {
  sensitive = true
  type = string
}