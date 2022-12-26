locals {
  domain_name = "whattheversion.hutter.cloud"
  zone_name = "hutter.cloud"
}

resource "aws_acm_certificate" "whattheversion" {
  domain_name       = local.domain_name
  validation_method = "DNS"
}

data "aws_route53_zone" "whattheversion" {
  name         = local.zone_name
  private_zone = false
}

resource "aws_route53_record" "whattheversion" {
  for_each = {
    for dvo in aws_acm_certificate.whattheversion.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.whattheversion.zone_id
}

resource "aws_acm_certificate_validation" "whattheversion" {
  certificate_arn         = aws_acm_certificate.whattheversion.arn
  validation_record_fqdns = [for record in aws_route53_record.whattheversion : record.fqdn]
}
