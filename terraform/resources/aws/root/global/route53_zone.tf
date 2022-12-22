data "aws_route53_zone" "hutter_cloud" {
  name         = "hutter.cloud."
  private_zone = false
}

output "hutter_cloud_zone_id" {
  value = data.aws_route53_zone.hutter_cloud.zone_id
}