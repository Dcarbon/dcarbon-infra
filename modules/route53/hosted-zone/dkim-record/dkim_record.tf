resource "aws_route53_record" "dkim-record" {
  count   = var.C_RECORD
  zone_id = var.HOSTED_ZONE_ID
  name    = "${element(var.DKIM_TOKENS, count.index)}._domainkey.${var.DOMAIN}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(var.DKIM_TOKENS, count.index)}.dkim.amazonses.com"]
}