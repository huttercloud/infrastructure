
resource "grafana_cloud_stack" "hutter_cloud" {
  name        = "huttercloud.grafana.net"
  slug        = "huttercloud"
  region_slug = "eu" # Example “us”,”eu” etc
}

resource "grafana_api_key" "metrics_publisher" {
  cloud_stack_slug = grafana_cloud_stack.hutter_cloud.slug
  name = "metrics-publisher"
  # role = "MetricsPublisher" # Error: expected role to be one of [Viewer Editor Admin], got MetricsPublisher
  role = "Admin"
}