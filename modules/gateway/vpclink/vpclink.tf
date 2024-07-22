resource "aws_apigatewayv2_vpc_link" "vpclink" {
  name               = var.NAME
  security_group_ids = var.SECURITY_GROUP_IDS
  subnet_ids         = var.SUBNET_IDS

  tags   = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}