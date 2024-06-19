output "cloudfront-zone-id" {
  value = aws_cloudfront_distribution.gateway-v2-distribution.hosted_zone_id
}
output "cloudfront-domain-name" {
  value = aws_cloudfront_distribution.gateway-v2-distribution.domain_name
}
output "cloudfront-arn" {
  value = aws_cloudfront_distribution.gateway-v2-distribution.arn
}
output "cloudfront-id" {
  value = aws_cloudfront_distribution.gateway-v2-distribution.id
}