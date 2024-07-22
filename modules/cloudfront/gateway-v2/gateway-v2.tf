locals {
  ORIGIN_ID = "gateway-${var.GATEWAY_ID}"
}
resource "aws_cloudfront_distribution" "gateway-v2-distribution" {
  origin {
    domain_name = var.GATEWAY_DOMAIN
    origin_id   = local.ORIGIN_ID
    origin_path = var.ORIGIN_PATH
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    dynamic "custom_header" {
      for_each = var.CUSTOM_HEADERS
      content {
        name  = lookup(custom_header.value, "name")
        value = lookup(custom_header.value, "value")
      }
    }
  }
  enabled         = true
  is_ipv6_enabled = true
  aliases         = [var.DOMAIN_NAME]
  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.ORIGIN_ID

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
      headers = var.FORWARDED_HEADERS
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
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
  tags       = merge({
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}