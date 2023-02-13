
# calibre opds feed basic auth secret
resource "aws_ssm_parameter" "hutter_cloud_calibre_opds_credentials" {
  name  = "hutter-cloud-calibre-opds-credentials"
  type  = "SecureString"
  value = local.secrets.calibre.opds.credentials
}
