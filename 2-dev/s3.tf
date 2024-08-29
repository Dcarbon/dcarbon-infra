locals {
  s3-common-bucket-name = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.COMMON}"
  s3-common-domain-name = "${var.PROJECT_NAME}-${var.ENV}-bucket.${var.CERT_DOMAIN}"
}
module "common-upload-bucket" {
  source                  = "../modules/s3/s3-oac"
  PROJECT_NAME            = var.PROJECT_NAME
  ENV                     = var.ENV
  PROJECT_SERVICE_TYPE    = var.PROJECT_SERVICES.COMMON
  TAGS                    = local.common-tags
  BUCKET_NAME             = local.s3-common-bucket-name
  TMP_FILE_NAME           = "s3-policy-oac.json.tpl"
  BLOCK_PUBLIC_ACLS       = true
  BLOCK_PUBLIC_POLICY     = true
  IGNORE_PUBLIC_ACLS      = true
  RESTRICT_PUBLIC_BUCKETS = true
  FORCE_DESTROY           = true
  USE_BUCKET_ACL          = true
  ACL_TYPE                = "private"
  VARIABLE = {
    LIST_PRIVATE_ACTION : jsonencode(["s3:PutObject", "s3:DeleteObject"])
    LIST_PRIVATE_DIR : jsonencode(["arn:aws:s3:::${local.s3-common-bucket-name}/*"])
    LIST_AWS_ARN : jsonencode([module.current-account.current_account_arn])
  }
  USE_BUCKET_CORS = true
  ALLOWED_HEADERS = ["*"]
  ALLOWED_METHODS = ["GET", "POST", "PUT"]
  ALLOWED_ORIGINS = ["*"]
  EXPOSE_HEADERS = [
    "ETag",
    "Access-Control-Allow-Origin",
    "Connection",
    "Content-Length"
  ]
}
module "s3-common-us-east-1-cert-for-cloudfront" {
  source            = "../modules/acm"
  DOMAIN_NAME       = local.s3-common-domain-name
  VALIDATION_METHOD = "DNS"
  TAGS              = local.common-tags
  providers = {
    aws = aws.us-east-1-provider
  }
}
module "s3-common-route53-record" {
  depends_on = [module.s3-common-us-east-1-cert-for-cloudfront]
  source                    = "../modules/route53/hosted-zone/acm-cert-record"
  HOSTED_ZONE_ID            = var.ROUTE53_HOSTED_ZONE.ID
  DOMAIN_VALIDATION_OPTIONS = module.s3-common-us-east-1-cert-for-cloudfront.domain_validation_options
  TAGS                      = local.common-tags
  providers = {
    aws = aws.route53-provider
  }
}
module "s3-common-cert-validation" {
  depends_on = [module.s3-common-route53-record]
  source          = "../modules/acm/validation"
  CERTIFICATE_ARN = module.s3-common-us-east-1-cert-for-cloudfront.cert-arn
  RECORD_FQDNS    = module.s3-common-route53-record.acm-cert-records-op
  providers = {
    aws = aws.us-east-1-provider
  }
}
module "s3-cloudfront-oac" {
  source                = "../modules/cloudfront/s3-oac"
  PROJECT_SERVICE_TYPE  = var.PROJECT_SERVICES.COMMON
  ENV                   = var.ENV
  PROJECT_NAME          = var.PROJECT_NAME
  TAGS                  = local.common-tags
  DOMAIN_NAME           = local.s3-common-domain-name
  CERT_ARN              = module.s3-common-us-east-1-cert-for-cloudfront.cert-arn
  S3_BUCKET_DOMAIN_NAME = module.common-upload-bucket.s3-bucket-domain-name
}
module "s3-common-cloudfront-route53-record" {
  depends_on = [module.s3-cloudfront-oac]
  source               = "../modules/route53/hosted-zone/alias-record"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.COMMON
  HOSTED_ZONE_ID       = var.ROUTE53_HOSTED_ZONE.ID
  RECORD_NAME          = local.s3-common-domain-name
  ALIAS_NAME           = module.s3-cloudfront-oac.cloudfront-domain-name
  ALIAS_ZONE_ID        = module.s3-cloudfront-oac.cloudfront-zone-id
  TAGS                 = local.common-tags
  providers = {
    aws = aws.us-east-1-route53-provider
  }
}
module "s3-oac-policy" {
  depends_on = [module.common-upload-bucket, module.user-application]
  source              = "../modules/s3/oac-policy"
  BUCKET_ID           = module.common-upload-bucket.s3-bucket-id
  PUBLIC_GET_RESOURCE = "${module.common-upload-bucket.s3-bucket-arn}/public/*"
  CLOUDFRONT_ARN      = module.s3-cloudfront-oac.cloudfront-arn
  ACCESS_RESOURCES = [
    "${module.common-upload-bucket.s3-bucket-arn}", "${module.common-upload-bucket.s3-bucket-arn}/*"
  ]
  ACCESS_RESOURCES_IDENTIFIERS = [module.user-application.user-arn, module.common-role.ecs-task-execute-role-arn, module.backend-admin-ecs-task-execute-role.role-arn]
}
module "s3-put-email-images" {
  depends_on = [module.admin-s3-static-website]
  source      = "../modules/s3/upload"
  BUCKET_ID   = module.common-upload-bucket.s3-bucket-id
  KEY         = ""
  SOURCE_PATH = "files/public/files/email/images"
  MIME_TYPES  = local.mime_types
}
module "s3-put-project-default-images" {
  depends_on = [module.admin-s3-static-website]
  source      = "../modules/s3/upload"
  BUCKET_ID   = module.common-upload-bucket.s3-bucket-id
  KEY         = ""
  SOURCE_PATH = "files/public/files/project/images/default"
  MIME_TYPES  = local.mime_types
}
module "s3-put-metadata-token-images" {
  depends_on = [module.admin-s3-static-website]
  source      = "../modules/s3/upload"
  BUCKET_ID   = module.common-upload-bucket.s3-bucket-id
  KEY         = ""
  SOURCE_PATH = "files/public/files/metadata/token"
  MIME_TYPES  = local.mime_types
}
module "s3-put-feedback-images" {
  depends_on = [module.admin-s3-static-website]
  source      = "../modules/s3/upload"
  BUCKET_ID   = module.common-upload-bucket.s3-bucket-id
  KEY         = ""
  SOURCE_PATH = "files/public/files/feedback"
  MIME_TYPES  = local.mime_types
}
module "s3-put-token-images" {
  depends_on = [module.admin-s3-static-website]
  source      = "../modules/s3/upload"
  BUCKET_ID   = module.common-upload-bucket.s3-bucket-id
  KEY         = ""
  SOURCE_PATH = "files/public/files/token"
  MIME_TYPES  = local.mime_types
}