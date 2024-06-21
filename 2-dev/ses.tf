locals {
  ses-domain-name = "${var.PROJECT_NAME}-mail.${var.CERT_DOMAIN}"
}
module "ses-domain" {
  source               = "../modules/ses"
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.COMMON
  TAGS                 = local.common-tags
  DOMAIN               = local.ses-domain-name
}
module "ses-route53-record" {
  depends_on = [module.ses-domain]
  source         = "../modules/route53/hosted-zone"
  TAGS           = local.common-tags
  HOSTED_ZONE_ID = var.ROUTE53_HOSTED_ZONE.ID
  RECORD_NAME    = "_amazonses.${local.ses-domain-name}"
  RECORDS = [join("", module.ses-domain.domain-verification-token)]
  RECORD_TYPE    = "TXT"
  TTL            = 600
  providers = {
    aws = aws.route53-provider
  }
}
module "ses-dkim-record" {
  depends_on = [module.ses-domain]
  source         = "../modules/route53/hosted-zone/dkim-record"
  C_RECORD       = 3
  DOMAIN         = local.ses-domain-name
  HOSTED_ZONE_ID = var.ROUTE53_HOSTED_ZONE.ID
  DKIM_TOKENS    = module.ses-domain.ses-dkim-tokens
  providers = {
    aws = aws.route53-provider
  }
}
