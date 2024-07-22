locals {
  backend-admin-domain = "${var.PROJECT_NAME}-${var.ENV}-admin-api.${var.CERT_DOMAIN}"
}
# module "backend-admin-cert-alb" {
#   source            = "../modules/acm"
#   DOMAIN_NAME       = local.backend-admin-domain
#   VALIDATION_METHOD = "DNS"
#   TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.BACKEND_ADMIN })
# }
# module "backend-admin-cert-alb-route53-record" {
#   depends_on = [module.backend-admin-cert-alb]
#   source                    = "../modules/route53/hosted-zone/acm-cert-record"
#   HOSTED_ZONE_ID            = var.ROUTE53_HOSTED_ZONE.ID
#   DOMAIN_VALIDATION_OPTIONS = module.backend-admin-cert-alb.domain_validation_options
#   TAGS                      = local.common-tags
#   providers = {
#     aws = aws.route53-provider
#   }
# }
# module "backend-admin-cert-alb-validation" {
#   depends_on = [module.backend-admin-cert-alb-route53-record]
#   source          = "../modules/acm/validation"
#   CERTIFICATE_ARN = module.backend-admin-cert-alb.cert-arn
#   RECORD_FQDNS    = module.backend-admin-cert-alb-route53-record.acm-cert-records-op
# }

module "backend-admin-vpclink-security-group" {
  source = "../modules/security-groups"
  #  depends_on                 = [module.vpc]
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_ADMIN
  SECURITY_GROUP_NAME  = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.BACKEND_ADMIN}-vpclink-sg"
  SECURITY_GROUP_DESCRIPTION = "(${var.ENV}) This Security Group use for ecs service of ${var.PROJECT_NAME} ${var.PROJECT_SERVICES.BACKEND_ADMIN}"
  #  VPC_ID                     = module.vpc.vpc_id
  VPC_ID               = var.VPC.ID
  SECURITY_GROUP_INBOUNDS = {
    "80" : {
      "description" : "Public http api to internet",
      "cidr_blocks" : ["0.0.0.0/0"]
      "security_groups" : [],
      "from_port" : 0,
      "to_port" : 0,
      "protocol" : "-1"
    }
  }
  TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.COMMON })
}

module "backend-admin-vpclink" {
  source               = "../modules/gateway/vpclink"
  ENV                  = var.ENV
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_ADMIN
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.PROJECT_SERVICES.BACKEND_ADMIN}"
  SECURITY_GROUP_IDS = [module.backend-admin-vpclink-security-group.security-group-id]
  SUBNET_IDS = [var.VPC.PRIVATE_SUBNETS[0]]
}
module "backend-admin-gateway-v2" {
  source          = "../modules/gateway/v2/gateway-v2-no-domain"
  ENV             = var.ENV
  PROJECT_NAME    = var.PROJECT_NAME
  PROJECT_SERVICE = var.PROJECT_SERVICES.BACKEND_ADMIN
  TAGS            = local.common-tags
}
# module "backend-admin-custom-domain-route53-record" {
#   depends_on = [module.backend-admin-gateway-v2]
#   source               = "../modules/route53/hosted-zone/alias-record"
#   HOSTED_ZONE_ID       = var.ROUTE53_HOSTED_ZONE.ID
#   PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_ADMIN
#   RECORD_NAME          = local.backend-admin-domain
#   ALIAS_NAME           = module.backend-admin-gateway-v2.gateway-domain-target-domain-name
#   ALIAS_ZONE_ID        = module.backend-admin-gateway-v2.gateway-domain-hosted-zone-id
#   TAGS                 = local.common-tags
#   providers = {
#     aws = aws.route53-provider
#   }
# }
module "backend-admin-gateway-route" {
  depends_on = [module.backend-admin-ecs-service]
  source           = "../modules/gateway/v2/route-vpc"
  INTEGRATION_TYPE = "HTTP_PROXY"
  INTEGRATION_URI  = module.backend-admin-discovery-service.discovery-service-arn
  API_ID           = module.backend-admin-gateway-v2.gateway-id
  ROUTE_KEY        = "$default"
  CONNECTION_TYPE  = "VPC_LINK"
  CONNECTION_ID    = module.backend-admin-vpclink.vpclink-id
}

module "backend-admin-cert-cloudfront" {
  source            = "../modules/acm"
  DOMAIN_NAME       = local.backend-admin-domain
  VALIDATION_METHOD = "DNS"
  TAGS              = local.common-tags
  providers = {
    aws = aws.us-east-1-provider
  }
}
module "backend-admin-cert-cloudfront-route53-record" {
  depends_on = [module.backend-admin-cert-cloudfront]
  source                    = "../modules/route53/hosted-zone/acm-cert-record"
  HOSTED_ZONE_ID            = var.ROUTE53_HOSTED_ZONE.ID
  DOMAIN_VALIDATION_OPTIONS = module.backend-admin-cert-cloudfront.domain_validation_options
  TAGS                      = local.common-tags
  providers = {
    aws = aws.us-east-1-route53-provider
  }
}
module "backend-admin-cert-cloudfront-validation" {
  depends_on = [module.backend-admin-cert-cloudfront-route53-record]
  source          = "../modules/acm/validation"
  CERTIFICATE_ARN = module.backend-admin-cert-cloudfront.cert-arn
  RECORD_FQDNS    = module.backend-admin-cert-cloudfront-route53-record.acm-cert-records-op
  providers = {
    aws = aws.us-east-1-provider
  }
}
module "backend-admin-gateway-cloudfront" {
  depends_on = [module.backend-admin-gateway-v2, module.backend-admin-cert-cloudfront-validation]
  source               = "../modules/cloudfront/gateway-v2"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_ADMIN
  TAGS                 = local.common-tags
  GATEWAY_ID           = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.BACKEND_ADMIN}"
  GATEWAY_DOMAIN = replace(module.backend-admin-gateway-v2.gateway-endpoint, "https://", "")
  CERT_ARN             = module.backend-admin-cert-cloudfront.cert-arn
  DOMAIN_NAME          = local.backend-admin-domain
  WAF_ID               = var.WAF_ID
  FORWARDED_HEADERS = [
    "Accept", "Authorization", "Origin", "Referer"
  ]
}

module "backend-admin-cloudfront-route53-record" {
  depends_on = [module.backend-admin-gateway-cloudfront]
  source               = "../modules/route53/hosted-zone/alias-record"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_ADMIN
  HOSTED_ZONE_ID       = var.ROUTE53_HOSTED_ZONE.ID
  RECORD_NAME          = local.backend-admin-domain
  ALIAS_NAME           = module.backend-admin-gateway-cloudfront.cloudfront-domain-name
  ALIAS_ZONE_ID        = module.backend-admin-gateway-cloudfront.cloudfront-zone-id
  TAGS                 = local.common-tags
  providers = {
    aws = aws.us-east-1-route53-provider
  }
}
