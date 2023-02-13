resource "aws_ssm_parameter" "hutter_cloud_service_oauth2_proxy_cookie_secret" {
  name  = "hutter-cloud-service-oauth2-proxy-cookie-secret"
  type  = "SecureString"
  value = local.secrets.oauth2proxy.cookiesecret
}
