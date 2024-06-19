output "cloudfront-zone-id" {
  value = aws_cloudfront_distribution.s3-static-website-distribution.hosted_zone_id
}
output "cloudfront-domain-name" {
  value = aws_cloudfront_distribution.s3-static-website-distribution.domain_name
}
output "cloudfront-arn" {
  value = aws_cloudfront_distribution.s3-static-website-distribution.arn
}
output "cloudfront-id" {
  value = aws_cloudfront_distribution.s3-static-website-distribution.id
}