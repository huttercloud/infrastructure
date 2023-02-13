# password for pihole web interface
resource "aws_ssm_parameter" "hutter_cloud_service_pihole_web_password" {
  name  = "hutter-cloud-service-pihole-web-password"
  type  = "SecureString"
  value = local.secrets.pihole.webpassword
}
