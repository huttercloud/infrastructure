#
# setup parameters in parameter store to be re-used in external-secrets
#

# dns zone for external-dns
resource "aws_ssm_parameter" "hutter_cloud_dns_zone_id" {
  name  = "hutter-cloud-dns-zone-id"
  type  = "String"
  value = data.terraform_remote_state.aws-root-global.outputs.hutter_cloud_zone_id
}

# iam credentials for dns access
resource "aws_ssm_parameter" "hutter_cloud_dns_access_key_id" {
  name  = "hutter-cloud-dns-access-key-id"
  type  = "SecureString"
  value = data.terraform_remote_state.aws-root-global.outputs.user_dns_access_key_id
}

resource "aws_ssm_parameter" "hutter_cloud_dns_secret_access_key" {
  name  = "hutter-cloud-dns-secret-access-key"
  type  = "SecureString"
  value = data.terraform_remote_state.aws-root-global.outputs.user_dns_secret_access_key
}

# iam credentials for parameter store
resource "aws_ssm_parameter" "hutter_cloud_ssm_access_key_id" {
  name  = "hutter-cloud-ssm-access-key-id"
  type  = "SecureString"
  value = data.terraform_remote_state.aws-root-global.outputs.user_parameter_store_access_key_id
}

resource "aws_ssm_parameter" "hutter_cloud_ssm_secret_access_key" {
  name  = "hutter-cloud-ssm-secret-access-key"
  type  = "SecureString"
  value = data.terraform_remote_state.aws-root-global.outputs.user_parameter_store_secret_access_key
}

# auth0 credentials for oauth2-proxy
resource "aws_ssm_parameter" "hutter_cloud_service_oauth2_proxy_client_id" {
  name  = "hutter-cloud-service-oauth2-proxy-client-id"
  type  = "SecureString"
  value = data.terraform_remote_state.auth0.outputs.oauth2_proxy_client_id
}

resource "aws_ssm_parameter" "hutter_cloud_service_oauth2_proxy_client_secret" {
  name  = "hutter-cloud-service-oauth2-proxy-client-secret"
  type  = "SecureString"
  value = data.terraform_remote_state.auth0.outputs.oauth2_proxy_client_secret
}

resource "aws_ssm_parameter" "hutter_cloud_service_oauth2_proxy_cookie_secret" {
  name  = "hutter-cloud-service-oauth2-proxy-cookie-secret"
  type  = "SecureString"
  value = var.oauth2_proxy_cookie_secret
}

# password for pihole web interface
resource "aws_ssm_parameter" "hutter_cloud_service_pihole_web_password" {
  name  = "hutter-cloud-service-pihole-web-password"
  type  = "SecureString"
  value = var.pi_hole_webpassword
}


# ssh private key for automatic ssl cert replacement
resource "aws_ssm_parameter" "hutter_cloud_service_synology_certificate_private_key" {
  name  = "hutter-cloud-service-synology-certificate-private-key"
  type  = "SecureString"
  value = var.synology_certificate_private_key
}

# grafana agent configuration
resource "aws_ssm_parameter" "hutter_cloud_grafana_prometheus_remote_endpoint_user_id" {
  name  = "hutter-cloud-grafana-prometheus-remote-endpoint-user-id"
  type  = "SecureString"
  value = data.terraform_remote_state.grafana.outputs.prometheus_remote_endpoint_user_id
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_prometheus_remote_endpoint_user_key" {
  name  = "hutter-cloud-grafana-prometheus-remote-endpoint-user-key"
  type  = "SecureString"
  value = var.grafana_cloud_metrics_publisher
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_prometheus_remote_write_endpoint" {
  name  = "hutter-cloud-grafana-prometheus-remote-write-endpoint"
  type  = "SecureString"
  value = data.terraform_remote_state.grafana.outputs.prometheus_remote_write_endpoint
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_logs_user_id" {
  name  = "hutter-cloud-grafana-logs-user-id"
  type  = "SecureString"
  value = data.terraform_remote_state.grafana.outputs.logs_user_id
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_logs_user_key" {
  name  = "hutter-cloud-grafana-logs-user-key"
  type  = "SecureString"
  value = var.grafana_cloud_metrics_publisher
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_logs_url" {
  name  = "hutter-cloud-grafana-logs-url"
  type  = "SecureString"
  value = data.terraform_remote_state.grafana.outputs.logs_url
}

# argo cd declarative setup
resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_host_node_a" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-host-node-a"
  type  = "SecureString"
  value = var.argo_cd_declarative_kubernetes_host_node_a
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_token_node_a" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-token-node-a"
  type  = "SecureString"
  value = var.argo_cd_declarative_kubernetes_token_node_a
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_cluster_ca_cert_data_node_a" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-cluster-ca-cert-data-node-a"
  type  = "SecureString"
  value = var.argo_cd_declarative_kubernetes_cluster_ca_cert_data_node_a
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_host_node_b" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-host-node-b"
  type  = "SecureString"
  value = var.argo_cd_declarative_kubernetes_host_node_b
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_token_node_b" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-token-node-b"
  type  = "SecureString"
  value = var.argo_cd_declarative_kubernetes_token_node_b
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_cluster_ca_cert_data_node_b" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-cluster-ca-cert-data-node-b"
  type  = "SecureString"
  value = var.argo_cd_declarative_kubernetes_cluster_ca_cert_data_node_b
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_github_applications_deploy_key" {
  name  = "hutter-cloud-argo-cd-declarative-github-applications-deploy-key"
  type  = "SecureString"
  value = var.argo_cd_declarative_github_applications_deploy_key
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_admin_password" {
  name  = "hutter-cloud-grafana-admin-password"
  type  = "SecureString"
  value = var.grafana_admin_password
}

resource "aws_ssm_parameter" "hutter_cloud_loki_gateway_credentials" {
  name  = "hutter-cloud-loki-gateway-credentials"
  type  = "SecureString"
  value = var.loki_gateway_credentials
}

