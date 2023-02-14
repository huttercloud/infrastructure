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
