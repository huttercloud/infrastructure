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

# auth0 client for pureftpd authentication
resource "aws_ssm_parameter" "hutter_cloud_service_pureftpd_client_id" {
  name  = "hutter-cloud-service-pureftpd-client-id"
  type  = "SecureString"
  value = data.terraform_remote_state.auth0.outputs.pureftpd_client_id
}

resource "aws_ssm_parameter" "hutter_cloud_service_pureftpd_client_secret" {
  name  = "hutter-cloud-service-pureftpd-client-secret"
  type  = "SecureString"
  value = data.terraform_remote_state.auth0.outputs.pureftpd_client_secret
}

resource "aws_ssm_parameter" "hutter_cloud_service_pureftpd_audience" {
  name  = "hutter-cloud-service-pureftpd-audience"
  type  = "SecureString"
  value = data.terraform_remote_state.auth0.outputs.pureftpd_audience
}

# auth0 client for jenkins auth0
resource "aws_ssm_parameter" "hutter_cloud_service_jenkins_client_id" {
  name  = "hutter-cloud-service-jenkins-client-id"
  type  = "SecureString"
  value = data.terraform_remote_state.auth0.outputs.jenkins_client_id
}

resource "aws_ssm_parameter" "hutter_cloud_service_jenkins_client_secret" {
  name  = "hutter-cloud-service-jenkins-client-secret"
  type  = "SecureString"
  value = data.terraform_remote_state.auth0.outputs.jenkins_client_secret
}
