resource "aws_acm_certificate" "cert" {
  domain_name               = var.DOMAIN_NAME
  subject_alternative_names = var.SUBJECT_ALTERNATIVE_NAMES
  validation_method         = var.VALIDATION_METHOD

  tags = var.TAGS

  lifecycle {
    create_before_destroy = true
  }
}
