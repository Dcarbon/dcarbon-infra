output "s3-bucket-name" {
  value = aws_s3_bucket.s3-bucket.bucket
}

output "s3-bucket-domain-name" {
  value = aws_s3_bucket.s3-bucket.bucket_regional_domain_name
}

output "s3-bucket-id" {
  value = aws_s3_bucket.s3-bucket.id
}

output "s3-bucket-arn" {
  value = aws_s3_bucket.s3-bucket.arn
}