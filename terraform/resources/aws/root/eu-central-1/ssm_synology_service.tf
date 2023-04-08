
# ssh private key for automatic ssl cert replacement
# NOT IN USE ANYNORE - USING BOUGHT CERTIFICATE
resource "aws_ssm_parameter" "hutter_cloud_service_synology_certificate_private_key" {
  name  = "hutter-cloud-service-synology-certificate-private-key"
  type  = "SecureString"
  value = base64decode(local.secrets.synology.certificate.privatekey)
}


