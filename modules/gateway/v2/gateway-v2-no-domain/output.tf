output "gateway-id" {
  value = aws_apigatewayv2_api.gateway-v2.id
}

output "gateway-endpoint" {
  value = aws_apigatewayv2_api.gateway-v2.api_endpoint
}