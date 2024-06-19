locals {
  backend-domain = "${var.PROJECT_NAME}-${var.ENV}-api.${var.CERT_DOMAIN}"
}
module "backend-cert-alb" {
  source            = "../modules/acm"
  DOMAIN_NAME       = local.backend-domain
  VALIDATION_METHOD = "DNS"
  TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.BACKEND })
}
module "backend-cert-alb-route53-record" {
  depends_on = [module.backend-cert-alb]
  source                    = "../modules/route53/hosted-zone/acm-cert-record"
  HOSTED_ZONE_ID            = var.ROUTE53_HOSTED_ZONE.ID
  DOMAIN_VALIDATION_OPTIONS = module.backend-cert-alb.domain_validation_options
  TAGS                      = local.common-tags
  providers = {
    aws = aws.route53-provider
  }
}
module "backend-cert-alb-validation" {
  depends_on = [module.backend-cert-alb-route53-record]
  source          = "../modules/acm/validation"
  CERTIFICATE_ARN = module.backend-cert-alb.cert-arn
  RECORD_FQDNS    = module.backend-cert-alb-route53-record.acm-cert-records-op
}

module "backend-vpclink-security-group" {
  source = "../modules/security-groups"
  #  depends_on                 = [module.vpc]
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND
  SECURITY_GROUP_NAME  = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.BACKEND}-vpclink-sg"
  SECURITY_GROUP_DESCRIPTION = "(${var.ENV}) This Security Group use for ecs service of ${var.PROJECT_NAME} ${var.PROJECT_SERVICES.BACKEND}"
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

module "backend-vpclink" {
  source               = "../modules/gateway/vpclink"
  ENV                  = var.ENV
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.PROJECT_SERVICES.BACKEND}"
  SECURITY_GROUP_IDS = [module.backend-vpclink-security-group.security-group-id]
  SUBNET_IDS = [var.VPC.PRIVATE_SUBNETS[0]]
}
module "backend-gateway-v2" {
  depends_on = [module.backend-cert-alb-validation]
  source           = "../modules/gateway/v2"
  ENV              = var.ENV
  PROJECT_NAME     = var.PROJECT_NAME
  PROJECT_SERVICE  = var.PROJECT_SERVICES.BACKEND
  TAGS             = local.common-tags
  IS_CUSTOM_DOMAIN = true
  DOMAIN_NAME      = local.backend-domain
  CERTIFICATE_ARN  = module.backend-cert-alb.cert-arn
}
module "backend-custom-domain-route53-record" {
  depends_on = [module.backend-gateway-v2]
  source               = "../modules/route53/hosted-zone/alias-record"
  HOSTED_ZONE_ID       = var.ROUTE53_HOSTED_ZONE.ID
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND
  RECORD_NAME          = local.backend-domain
  ALIAS_NAME           = module.backend-gateway-v2.gateway-domain-target-domain-name
  ALIAS_ZONE_ID        = module.backend-gateway-v2.gateway-domain-hosted-zone-id
  TAGS                 = local.common-tags
  providers = {
    aws = aws.route53-provider
  }
}
module "backend-gateway-route" {
  depends_on = [module.backend-ecs-service]
  source           = "../modules/gateway/v2/route-vpc"
  INTEGRATION_TYPE = "HTTP_PROXY"
  INTEGRATION_URI  = module.backend-discovery-service.discovery-service-arn
  API_ID           = module.backend-gateway-v2.gateway-id
  ROUTE_KEY        = "$default"
  CONNECTION_TYPE  = "VPC_LINK"
  CONNECTION_ID    = module.backend-vpclink.vpclink-id
}