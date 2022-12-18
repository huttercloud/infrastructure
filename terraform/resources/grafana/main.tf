
resource "grafana_cloud_stack" "hutter_cloud" {
  name        = "huttercloud.grafana.net"
  slug        = "huttercloud"
  region_slug = "eu" # Example “us”,”eu” etc
}