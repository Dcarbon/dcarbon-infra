locals {
  po-s3-static-web-bucket  = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.ADMIN_PO}"
  po-domain-name           = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.ADMIN_PO}.${var.CERT_DOMAIN}"
}
//WEB
module "po-react-js-build" {
  source      = "../modules/build/react-js"
  SOURCE_PATH = "${path.cwd}/../../${local.build-project-name-admin}"
  REACT_APP_ENV = {
    REACT_APP_STAGE : var.ENV
  }
}

module "po-s3-static-website" {
  depends_on = [module.po-react-js-build]
  source               = "../modules/s3/static-website"
  AWS_REGION           = var.AWS_REGION
  AWS_ACCESS_KEY       = var.AWS_ACCESS_KEY
  AWS_SECRET_KEY       = var.AWS_SECRET_KEY
  ENV                  = var.ENV
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.ADMIN_PO
  TAGS                 = local.common-tags
  BUCKET_NAME          = local.po-s3-static-web-bucket
  USER_CICD            = "arn:aws:iam::${module.current-account.current_account_id}:user/${var.PROJECT_NAME}-cicd"
  SOURCE_PATH          = "${path.cwd}/../../${local.build-project-name-admin}/dist"
  MIME_TYPES           = local.mime_types
  FORCE_DESTROY        = true
}
module "po-cert-cloudfront" {
  source            = "../modules/acm"
  DOMAIN_NAME       = local.po-domain-name
  VALIDATION_METHOD = "DNS"
  TAGS              = local.common-tags
  providers = {
    aws = aws.us-east-1-provider
  }
}
module "po-cert-cloudfront-route53-record" {
  depends_on = [module.po-cert-cloudfront]
  source                    = "../modules/route53/hosted-zone/acm-cert-record"
  HOSTED_ZONE_ID            = var.ROUTE53_HOSTED_ZONE.ID
  DOMAIN_VALIDATION_OPTIONS = module.po-cert-cloudfront.domain_validation_options
  TAGS                      = local.common-tags
  providers = {
    aws = aws.us-east-1-route53-provider
  }
}
module "po-cert-cloudfront-validation" {
  depends_on = [module.po-cert-cloudfront-route53-record]
  source          = "../modules/acm/validation"
  CERTIFICATE_ARN = module.po-cert-cloudfront.cert-arn
  RECORD_FQDNS    = module.po-cert-cloudfront-route53-record.acm-cert-records-op
  providers = {
    aws = aws.us-east-1-provider
  }
}
module "po-s3-static-website-cloudfront" {
  depends_on = [module.po-s3-static-website, module.po-cert-cloudfront-validation]
  source               = "../modules/cloudfront/s3-static-website"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.ADMIN_PO
  TAGS                 = local.common-tags
  S3_BUCKET_NAME       = local.po-s3-static-web-bucket
  CERT_ARN             = module.po-cert-cloudfront.cert-arn
  DOMAIN_NAME          = local.po-domain-name
  S3_STATIC_WEB_DOMAIN = module.po-s3-static-website.s3-web-static-endpoint
  WAF_ID               = var.WAF_ID
}
module "po-cloudfront-route53-record" {
  depends_on = [module.po-s3-static-website-cloudfront]
  source               = "../modules/route53/hosted-zone/alias-record"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.ADMIN_PO
  HOSTED_ZONE_ID       = var.ROUTE53_HOSTED_ZONE.ID
  RECORD_NAME          = local.po-domain-name
  ALIAS_NAME           = module.po-s3-static-website-cloudfront.cloudfront-domain-name
  ALIAS_ZONE_ID        = module.po-s3-static-website-cloudfront.cloudfront-zone-id
  TAGS                 = local.common-tags
  providers = {
    aws = aws.us-east-1-route53-provider
  }
}