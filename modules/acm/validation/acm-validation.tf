resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn         = var.CERTIFICATE_ARN
  validation_record_fqdns = [for record in var.RECORD_FQDNS : record["fqdn"]]
}