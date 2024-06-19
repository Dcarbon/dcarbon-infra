output "gateway-domain-hosted-zone-id" {
  value = aws_apigatewayv2_domain_name.gateway-domain.domain_name_configuration[0].hosted_zone_id
}

output "gateway-domain-target-domain-name" {
  value = aws_apigatewayv2_domain_name.gateway-domain.domain_name_configuration[0].target_domain_name
}

output "gateway-id" {
  value = aws_apigatewayv2_api.gateway-v2.id
}

output "gateway-endpoint" {
  value = aws_apigatewayv2_api.gateway-v2.api_endpoint
}