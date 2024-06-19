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