locals {
  origin-id = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}-bucket"
}
data "aws_cloudfront_cache_policy" "cache-policy" {
  name = "Managed-CachingOptimized"
}
data "aws_cloudfront_origin_request_policy" "request-policy" {
  name = "Managed-CORS-S3Origin"
}
resource "aws_cloudfront_origin_access_control" "cloudfront-s3-oac" {
  name                              = "${var.PROJECT_NAME}-${var.ENV}-CloudFront S3 OAC"
  description                       = "Cloud Front S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3-oac-distribution" {

  origin {
    domain_name = var.S3_BUCKET_DOMAIN_NAME
    origin_id   = local.origin-id

    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront-s3-oac.id

  }

  enabled = true
  aliases = [var.DOMAIN_NAME]
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin-id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id = data.aws_cloudfront_cache_policy.cache-policy.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.request-policy.id
  }
  viewer_certificate {
    # Huh? Another spoiler?
    acm_certificate_arn      = var.CERT_ARN
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags  = merge({
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}