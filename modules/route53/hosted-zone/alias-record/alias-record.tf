resource "aws_route53_record" "alias-record" {
  zone_id = var.HOSTED_ZONE_ID
  name    = var.RECORD_NAME
  type    = "A"
  alias {
    name                   = var.ALIAS_NAME
    zone_id                = var.ALIAS_ZONE_ID
    evaluate_target_health = var.TARGET_HEALTH
  }
}
