locals {
  waf-common-tags = {
    terraform = "true"
    prj       = var.PROJECT_NAME
    env       = "all"
    cus       = var.PROJECT_NAME
  }
}
module "ipv4-white-list" {
  source = "../modules/waf/ip-set"
  TAGS = merge(local.waf-common-tags, {
    Name = "${var.PROJECT_NAME} ipv4 white list",
  })
  NAME               = "${var.PROJECT_NAME}-ipv4-white-list"
  DESCRIPTION        = "White list ipv4 ${var.PROJECT_NAME}"
  SCOPE              = "CLOUDFRONT"
  IP_ADDRESS_VERSION = "IPV4"
  ADDRESSES          = var.IP_WHITE_LIST
  providers = {
    aws = aws.us-east-1-provider
  }
}

module "ipv6-white-list" {
  source = "../modules/waf/ip-set"
  TAGS = merge(local.waf-common-tags, {
    Name = "${var.PROJECT_NAME} ipv6 white list",
  })
  NAME               = "${var.PROJECT_NAME}-ipv6-white-list"
  DESCRIPTION        = "White list ipv6 ${var.PROJECT_NAME}"
  SCOPE              = "CLOUDFRONT"
  IP_ADDRESS_VERSION = "IPV6"
  ADDRESSES = []
  providers = {
    aws = aws.us-east-1-provider
  }
}

module "ip-web-acl" {
  source = "../modules/waf"
  TAGS = merge(local.waf-common-tags, {
    Name = "${var.PROJECT_NAME} ip Web acl",
  })
  NAME             = "${var.PROJECT_NAME}-ip-web-acl"
  DESCRIPTION      = "${var.PROJECT_NAME} IP Web Acl"
  SCOPE            = "CLOUDFRONT"
  IP_SET_ARN       = module.ipv4-white-list.ip-set-arn
  IP_SET_V6_ARN    = module.ipv6-white-list.ip-set-arn
  IP_SET_RULE_NAME = "allow-${var.PROJECT_NAME}-ip-white-list"
  providers = {
    aws = aws.us-east-1-provider
  }
}