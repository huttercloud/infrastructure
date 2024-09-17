locals {
  ks_domain_name = "kulturstreuer-toess.ch"
}

# ACM validation is done manually via novatrend dns manager
resource "aws_acm_certificate" "kulturstreuer" {
  domain_name       = local.ks_domain_name
  validation_method = "DNS"
}

