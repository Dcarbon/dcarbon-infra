output "s3-web-static-endpoint" {
  value = aws_s3_bucket_website_configuration.bucket-website-config.website_endpoint
}
output "s3-bucket-id" {
  value = aws_s3_bucket.s3-bucket.id
}