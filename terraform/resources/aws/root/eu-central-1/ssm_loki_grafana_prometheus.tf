# grafana agent configuration
resource "aws_ssm_parameter" "hutter_cloud_grafana_prometheus_remote_endpoint_user_id" {
  name  = "hutter-cloud-grafana-prometheus-remote-endpoint-user-id"
  type  = "SecureString"
  value = data.terraform_remote_state.grafana.outputs.prometheus_remote_endpoint_user_id
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_prometheus_remote_endpoint_user_key" {
  name  = "hutter-cloud-grafana-prometheus-remote-endpoint-user-key"
  type  = "SecureString"
  value = local.secrets.grafana.cloudmetrics.publisher
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
  value = local.secrets.grafana.cloudmetrics.publisher
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_logs_url" {
  name  = "hutter-cloud-grafana-logs-url"
  type  = "SecureString"
  value = data.terraform_remote_state.grafana.outputs.logs_url
}

resource "aws_ssm_parameter" "hutter_cloud_grafana_admin_password" {
  name  = "hutter-cloud-grafana-admin-password"
  type  = "SecureString"
  value = local.secrets.grafana.admin.password
}

resource "aws_ssm_parameter" "hutter_cloud_loki_gateway_credentials" {
  name  = "hutter-cloud-loki-gateway-credentials"
  type  = "SecureString"
  value = local.secrets.loki.gateway.credentials
}
