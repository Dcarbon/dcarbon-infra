resource "aws_apigatewayv2_route" "gateway-v2-route" {
  api_id    = var.API_ID
  route_key = var.ROUTE_KEY
  target    = "integrations/${aws_apigatewayv2_integration.gateway-v2-integration.id}"
}

resource "aws_apigatewayv2_integration" "gateway-v2-integration" {
  api_id             = var.API_ID
  integration_type   = var.INTEGRATION_TYPE
  integration_uri    = var.INTEGRATION_URI
  integration_method = "ANY"

  request_parameters = var.REQUEST_PARAMETERS
}