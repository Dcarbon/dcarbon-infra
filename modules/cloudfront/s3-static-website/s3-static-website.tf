locals {
  ORIGIN_ID = "S3-${var.S3_BUCKET_NAME}"
}
resource "aws_cloudfront_distribution" "s3-static-website-distribution" {
  origin {
    domain_name              = var.S3_STATIC_WEB_DOMAIN
    origin_id                = local.ORIGIN_ID
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"
  aliases = [var.DOMAIN_NAME]
  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.ORIGIN_ID

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 1
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.CERT_ARN
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  web_acl_id = var.WAF_ID
  tags  = merge({
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}