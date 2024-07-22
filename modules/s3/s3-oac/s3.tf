resource "aws_s3_bucket" "s3-bucket" {
  bucket        = var.BUCKET_NAME
  force_destroy = var.FORCE_DESTROY
  tags          = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}
resource "aws_s3_bucket_public_access_block" "bucket-public-access" {
  depends_on = [aws_s3_bucket.s3-bucket]
  bucket     = aws_s3_bucket.s3-bucket.id

  block_public_acls       = var.BLOCK_PUBLIC_ACLS
  block_public_policy     = var.BLOCK_PUBLIC_POLICY
  ignore_public_acls      = var.IGNORE_PUBLIC_ACLS
  restrict_public_buckets = var.RESTRICT_PUBLIC_BUCKETS
}
resource "aws_s3_bucket_policy" "bucket-policy" {
  depends_on = [aws_s3_bucket_public_access_block.bucket-public-access]
  bucket     = aws_s3_bucket.s3-bucket.id
  policy     = templatefile("${path.module}/../templates/${var.TMP_FILE_NAME}", var.VARIABLE)
}
#resource "aws_s3_bucket_acl" "s3_bucket_acl" {
#  count  = var.USE_BUCKET_ACL ? 1 : 0
#  bucket = aws_s3_bucket.s3-bucket.id
#  acl    = var.ACL_TYPE
#}

resource "aws_s3_bucket_cors_configuration" "bucket-cors" {
  count  = var.USE_BUCKET_CORS ? 1 : 0
  bucket = aws_s3_bucket.s3-bucket.id

  cors_rule {
    allowed_headers = var.ALLOWED_HEADERS
    allowed_methods = var.ALLOWED_METHODS
    allowed_origins = var.ALLOWED_ORIGINS
    max_age_seconds = var.MAX_AGE_SECONDS
    expose_headers =  var.EXPOSE_HEADERS
  }


}