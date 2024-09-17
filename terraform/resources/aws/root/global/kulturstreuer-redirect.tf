locals {
  # arn is created in us-east-1, see corresponding code
  ks_acm_arn = "arn:aws:acm:us-east-1:337261303015:certificate/e15021d4-9539-4983-b13d-48c2e1f4944c"
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
  comment             = "kulturstreuer.ch"
  default_root_object = "index.html"

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
