# iam credentials for parameter store
resource "aws_ssm_parameter" "hutter_cloud_secrets_manager_secret_access_key_id" {
  name  = "hutter-cloud-secrets-manager-access-key-id"
  type  = "SecureString"
  value = data.terraform_remote_state.aws-root-global.outputs.user_secrets_manager_access_key_id
}

resource "aws_ssm_parameter" "hutter_cloud_secrets_manager_secret_access_key" {
  name  = "hutter-cloud-secrets-manager-secret-access-key"
  type  = "SecureString"
  value = data.terraform_remote_state.aws-root-global.outputs.user_secrets_manager_secret_access_key
}
