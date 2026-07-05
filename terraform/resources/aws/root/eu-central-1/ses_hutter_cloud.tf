#
# SES domain identity for hutter.cloud including DKIM, a custom MAIL FROM
# domain and all required Route53 records (verification, DKIM, SPF, DMARC).
#

locals {
  ses_domain  = "hutter.cloud"
  ses_zone_id = data.terraform_remote_state.aws-root-global.outputs.hutter_cloud_zone_id
}

data "aws_region" "current" {}

# domain identity that we want to send mail from
resource "aws_ses_domain_identity" "hutter_cloud" {
  domain = local.ses_domain
}

# domain verification TXT record
resource "aws_route53_record" "ses_verification" {
  zone_id = local.ses_zone_id
  name    = "_amazonses.${local.ses_domain}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.hutter_cloud.verification_token]
}

# wait until AWS has verified the domain via the TXT record above
resource "aws_ses_domain_identity_verification" "hutter_cloud" {
  domain     = aws_ses_domain_identity.hutter_cloud.id
  depends_on = [aws_route53_record.ses_verification]
}

# DKIM signing for the domain
resource "aws_ses_domain_dkim" "hutter_cloud" {
  domain = aws_ses_domain_identity.hutter_cloud.domain
}

# the three CNAME records required for DKIM
resource "aws_route53_record" "ses_dkim" {
  count   = 3
  zone_id = local.ses_zone_id
  name    = "${aws_ses_domain_dkim.hutter_cloud.dkim_tokens[count.index]}._domainkey.${local.ses_domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["${aws_ses_domain_dkim.hutter_cloud.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

# while the SES account is in sandbox mode we can only send to verified
# recipient addresses - verify the notification target here. AWS sends a
# confirmation mail to this address that has to be clicked once.
resource "aws_ses_email_identity" "notification_recipient" {
  email = "huttersebastian@gmail.com"
}

output "ses_domain_identity_arn" {
  value = aws_ses_domain_identity.hutter_cloud.arn
}
