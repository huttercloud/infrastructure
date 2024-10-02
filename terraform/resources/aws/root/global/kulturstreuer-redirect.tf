locals {
  # arn is created in us-east-1, see corresponding code
  ks_acm_arn = "arn:aws:acm:us-east-1:337261303015:certificate/c7180128-7c0d-4c7c-95a7-66d3d4550913"
}


# dns zone for kstreuer
resource "aws_route53_zone" "kulturstreuer" {
  name = "kulturstreuer-toess.ch"
}

# bucket for destination, not in use as all redirects are handled via cloudfront function
resource "aws_s3_bucket" "kulturstreuer" {
  bucket = "kulturstreuer-redirect"
}

resource "aws_cloudfront_function" "kulturstreuer" {
  name    = "kulturstreuer"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/kulturstreuer-function.js")
}

resource "aws_cloudfront_distribution" "kulturstreuer" {
  origin {
    domain_name = aws_s3_bucket.kulturstreuer.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.kulturstreuer.bucket_regional_domain_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "kulturstreuer-toess.ch"
  default_root_object = "index.html"
  aliases = [
    "kulturstreuer-toess.ch",
    "www.kulturstreuer-toess.ch",
  ]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.kulturstreuer.bucket_regional_domain_name
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.kulturstreuer.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = local.ks_acm_arn
    ssl_support_method  = "sni-only"
  }

  price_class = "PriceClass_100"
}

# cloudfront distribution alias records
resource "aws_route53_record" "kulturstreuer" {
  zone_id = aws_route53_zone.kulturstreuer.zone_id
  name    = "kulturstreuer-toess.ch"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.kulturstreuer.domain_name
    zone_id                = aws_cloudfront_distribution.kulturstreuer.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "kulturstreuer_www" {
  zone_id = aws_route53_zone.kulturstreuer.zone_id
  name    = "www.kulturstreuer-toess.ch"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.kulturstreuer.domain_name
    zone_id                = aws_cloudfront_distribution.kulturstreuer.hosted_zone_id
    evaluate_target_health = false
  }
}

# acm cert validation records (acm is setup in us-east-1, manually adding the validation here for now)

locals {
  acm_validation_records = {
    "_9c8719a6b4d21a6962d5cd9d17b01866.www.kulturstreuer-toess.ch" = "_ea38fd486da9a7ebd1fb5c712ee834a4.djqtsrsxkq.acm-validations.aws"
    "_9c8719a6b4d21a6962d5cd9d17b01866.kulturstreuer-toess.ch"     = "_9c987d8287af804ae604b82d617826d9.djqtsrsxkq.acm-validations.aws"
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = local.acm_validation_records

  ttl     = 300
  zone_id = aws_route53_zone.kulturstreuer.zone_id
  name    = each.key
  type    = "CNAME"
  records = [each.value]
}
