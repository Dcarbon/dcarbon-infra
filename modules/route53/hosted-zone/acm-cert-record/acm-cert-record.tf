resource "aws_route53_record" "acm-cert-records" {
  for_each = {
    for dvo in var.DOMAIN_VALIDATION_OPTIONS : dvo["domain_name"] => {
      name   = dvo["resource_record_name"]
      record = dvo["resource_record_value"]
      type   = dvo["resource_record_type"]
    }
  }

  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = var.HOSTED_ZONE_ID
}