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
