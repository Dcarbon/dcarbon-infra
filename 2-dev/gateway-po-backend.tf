locals {
  backend-po-domain = "${var.PROJECT_NAME}-${var.ENV}-po-api.${var.CERT_DOMAIN}"
}
module "backend-po-cert-alb" {
  source            = "../modules/acm"
  DOMAIN_NAME       = local.backend-po-domain
  VALIDATION_METHOD = "DNS"
  TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.BACKEND_PO })
}
module "backend-po-cert-alb-route53-record" {
  depends_on = [module.backend-po-cert-alb]
  source                    = "../modules/route53/hosted-zone/acm-cert-record"
  HOSTED_ZONE_ID            = var.ROUTE53_HOSTED_ZONE.ID
  DOMAIN_VALIDATION_OPTIONS = module.backend-po-cert-alb.domain_validation_options
  TAGS                      = local.common-tags
  providers = {
    aws = aws.route53-provider
  }
}
module "backend-po-cert-alb-validation" {
  depends_on = [module.backend-po-cert-alb-route53-record]
  source          = "../modules/acm/validation"
  CERTIFICATE_ARN = module.backend-po-cert-alb.cert-arn
  RECORD_FQDNS    = module.backend-po-cert-alb-route53-record.acm-cert-records-op
}

module "backend-po-vpclink-security-group" {
  source = "../modules/security-groups"
  #  depends_on                 = [module.vpc]
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_PO
  SECURITY_GROUP_NAME  = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.BACKEND_PO}-vpclink-sg"
  SECURITY_GROUP_DESCRIPTION = "(${var.ENV}) This Security Group use for ecs service of ${var.PROJECT_NAME} ${var.PROJECT_SERVICES.BACKEND_PO}"
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

module "backend-po-vpclink" {
  source               = "../modules/gateway/vpclink"
  ENV                  = var.ENV
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_PO
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.PROJECT_SERVICES.BACKEND_PO}"
  SECURITY_GROUP_IDS = [module.backend-po-vpclink-security-group.security-group-id]
  SUBNET_IDS = [var.VPC.PRIVATE_SUBNETS[0]]
}
module "backend-po-gateway-v2" {
  depends_on = [module.backend-po-cert-alb-validation]
  source           = "../modules/gateway/v2"
  ENV              = var.ENV
  PROJECT_NAME     = var.PROJECT_NAME
  PROJECT_SERVICE  = var.PROJECT_SERVICES.BACKEND_PO
  TAGS             = local.common-tags
  IS_CUSTOM_DOMAIN = true
  DOMAIN_NAME      = local.backend-po-domain
  CERTIFICATE_ARN  = module.backend-po-cert-alb.cert-arn
}
module "backend-po-custom-domain-route53-record" {
  depends_on = [module.backend-po-gateway-v2]
  source               = "../modules/route53/hosted-zone/alias-record"
  HOSTED_ZONE_ID       = var.ROUTE53_HOSTED_ZONE.ID
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_PO
  RECORD_NAME          = local.backend-po-domain
  ALIAS_NAME           = module.backend-po-gateway-v2.gateway-domain-target-domain-name
  ALIAS_ZONE_ID        = module.backend-po-gateway-v2.gateway-domain-hosted-zone-id
  TAGS                 = local.common-tags
  providers = {
    aws = aws.route53-provider
  }
}
module "backend-po-gateway-route" {
  depends_on = [module.backend-po-ecs-service]
  source           = "../modules/gateway/v2/route-vpc"
  INTEGRATION_TYPE = "HTTP_PROXY"
  INTEGRATION_URI  = module.backend-po-discovery-service.discovery-service-arn
  API_ID           = module.backend-po-gateway-v2.gateway-id
  ROUTE_KEY        = "$default"
  CONNECTION_TYPE  = "VPC_LINK"
  CONNECTION_ID    = module.backend-po-vpclink.vpclink-id
}