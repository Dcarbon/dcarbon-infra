resource "aws_wafv2_web_acl_association" "web-acl-association" {
  resource_arn = var.RESOURCE_ARN
  web_acl_arn  = var.WEB_ACL_ARN
}