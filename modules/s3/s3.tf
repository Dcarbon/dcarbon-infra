resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.BUCKET_NAME
  force_destroy = var.FORCE_DESTROY
  tags   = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}
resource "aws_s3_bucket_public_access_block" "bucket-public-access" {
  depends_on = [aws_s3_bucket.s3-bucket]
  bucket     = aws_s3_bucket.s3-bucket.id

  block_public_acls   = false
  block_public_policy = false
}
resource "aws_s3_bucket_policy" "bucket-policy" {
  depends_on = [aws_s3_bucket_public_access_block.bucket-public-access]
  bucket     = aws_s3_bucket.s3-bucket.id
  policy     = templatefile("${path.module}/templates/${var.TMP_FILE_NAME}", var.VARIABLE)
}