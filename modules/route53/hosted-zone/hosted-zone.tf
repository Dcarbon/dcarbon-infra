resource "aws_route53_record" "route53-record" {
  zone_id = var.HOSTED_ZONE_ID
  name    = var.RECORD_NAME
  type    = var.RECORD_TYPE
  ttl     = var.TTL
  records        = var.RECORDS
}
