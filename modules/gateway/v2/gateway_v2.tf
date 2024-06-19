resource "aws_apigatewayv2_api" "gateway-v2" {
  name          = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE}-gateway"
  protocol_type = var.PROTOCOL_TYPE
  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}"
  }, var.TAGS)
}

resource "aws_apigatewayv2_stage" "gateway-v2-stage" {
  api_id = aws_apigatewayv2_api.gateway-v2.id
  name   = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "gateway-domain" {
  domain_name = var.DOMAIN_NAME

  domain_name_configuration {
    certificate_arn = var.CERTIFICATE_ARN
    endpoint_type   = var.ENDPOINT_TYPE
    security_policy = "TLS_1_2"
  }
  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}"
  }, var.TAGS)
}

resource "aws_apigatewayv2_api_mapping" "gateway-domain-mapping" {
  api_id      = aws_apigatewayv2_api.gateway-v2.id
  domain_name = aws_apigatewayv2_domain_name.gateway-domain.id
  stage = aws_apigatewayv2_stage.gateway-v2-stage.id
}