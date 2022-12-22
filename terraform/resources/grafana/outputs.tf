output "prometheus_remote_endpoint" {
  value = grafana_cloud_stack.hutter_cloud.prometheus_remote_endpoint
}

output "prometheus_remote_write_endpoint" {
  value = grafana_cloud_stack.hutter_cloud.prometheus_remote_write_endpoint
}

output "prometheus_remote_endpoint_user_id" {
  value = grafana_cloud_stack.hutter_cloud.prometheus_user_id
}

output "logs_url" {
  value = grafana_cloud_stack.hutter_cloud.logs_url
}

output "logs_user_id" {
  value = grafana_cloud_stack.hutter_cloud.logs_user_id
}