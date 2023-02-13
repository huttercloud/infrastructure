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
