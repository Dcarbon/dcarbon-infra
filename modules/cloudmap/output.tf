output "cloudmap-arn" {
  value = aws_service_discovery_private_dns_namespace.namespace.arn
}

output "cloudmap-id" {
  value = aws_service_discovery_private_dns_namespace.namespace.id
}