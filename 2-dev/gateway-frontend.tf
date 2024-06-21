locals {
  frontend-domain = "${var.PROJECT_NAME}-${var.ENV}.${var.CERT_DOMAIN}"
}
module "frontend-vpclink-security-group" {
  source = "../modules/security-groups"
  #  depends_on                 = [module.vpc]
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.FRONTEND
  SECURITY_GROUP_NAME  = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.FRONTEND}-vpclink-sg"
  SECURITY_GROUP_DESCRIPTION = "(${var.ENV}) This Security Group use for ecs service of ${var.PROJECT_NAME} ${var.PROJECT_SERVICES.FRONTEND}"
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
  TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.FRONTEND })
}

module "frontend-vpclink" {
  source               = "../modules/gateway/vpclink"
  ENV                  = var.ENV
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.FRONTEND
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.PROJECT_SERVICES.FRONTEND}"
  SECURITY_GROUP_IDS = [module.frontend-vpclink-security-group.security-group-id]
  SUBNET_IDS = [var.VPC.PRIVATE_SUBNETS[0]]
}
module "frontend-gateway-v2" {
  source          = "../modules/gateway/v2/gateway-v2-no-domain"
  ENV             = var.ENV
  PROJECT_NAME    = var.PROJECT_NAME
  PROJECT_SERVICE = var.PROJECT_SERVICES.FRONTEND
  TAGS            = local.common-tags
}
module "frontend-gateway-route" {
  depends_on = [module.frontend-ecs-service]
  source           = "../modules/gateway/v2/route-vpc"
  INTEGRATION_TYPE = "HTTP_PROXY"
  INTEGRATION_URI  = module.frontend-discovery-service.discovery-service-arn
  API_ID           = module.frontend-gateway-v2.gateway-id
  ROUTE_KEY        = "$default"
  CONNECTION_TYPE  = "VPC_LINK"
  CONNECTION_ID    = module.frontend-vpclink.vpclink-id
  REQUEST_PARAMETERS = {
    "overwrite:header.host" = local.frontend-domain
  }
}
module "frontend-cert-cloudfront" {
  source            = "../modules/acm"
  DOMAIN_NAME       = local.frontend-domain
  VALIDATION_METHOD = "DNS"
  TAGS              = local.common-tags
  providers = {
    aws = aws.us-east-1-provider
  }
}
module "frontend-cert-cloudfront-route53-record" {
  depends_on = [module.frontend-cert-cloudfront]
  source                    = "../modules/route53/hosted-zone/acm-cert-record"
  HOSTED_ZONE_ID            = var.ROUTE53_HOSTED_ZONE.ID
  DOMAIN_VALIDATION_OPTIONS = module.frontend-cert-cloudfront.domain_validation_options
  TAGS                      = local.common-tags
  providers = {
    aws = aws.us-east-1-route53-provider
  }
}
module "frontend-cert-cloudfront-validation" {
  depends_on = [module.frontend-cert-cloudfront-route53-record]
  source          = "../modules/acm/validation"
  CERTIFICATE_ARN = module.frontend-cert-cloudfront.cert-arn
  RECORD_FQDNS    = module.frontend-cert-cloudfront-route53-record.acm-cert-records-op
  providers = {
    aws = aws.us-east-1-provider
  }
}
module "frontend-gateway-cloudfront" {
  depends_on = [module.frontend-gateway-v2, module.frontend-cert-cloudfront-validation]
  source               = "../modules/cloudfront/gateway-v2"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.FRONTEND
  TAGS                 = local.common-tags
  GATEWAY_ID           = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.FRONTEND}"
  GATEWAY_DOMAIN = replace(module.frontend-gateway-v2.gateway-endpoint, "https://", "")
  CERT_ARN             = module.frontend-cert-cloudfront.cert-arn
  DOMAIN_NAME          = local.frontend-domain
  WAF_ID               = var.WAF_ID
}

module "frontend-cloudfront-route53-record" {
  depends_on = [module.frontend-gateway-cloudfront]
  source               = "../modules/route53/hosted-zone/alias-record"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.FRONTEND
  HOSTED_ZONE_ID       = var.ROUTE53_HOSTED_ZONE.ID
  RECORD_NAME          = local.frontend-domain
  ALIAS_NAME           = module.frontend-gateway-cloudfront.cloudfront-domain-name
  ALIAS_ZONE_ID        = module.frontend-gateway-cloudfront.cloudfront-zone-id
  TAGS                 = local.common-tags
  providers = {
    aws = aws.us-east-1-route53-provider
  }
}
