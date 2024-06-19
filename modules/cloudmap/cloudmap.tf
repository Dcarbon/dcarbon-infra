resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name        = var.NAMESPACE_NAME
  description = var.DESCRIPTION
  vpc         = var.VPC_ID
  tags         = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}"
  }, var.TAGS)
}