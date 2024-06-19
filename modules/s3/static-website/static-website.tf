resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.BUCKET_NAME
  force_destroy = var.FORCE_DESTROY
  tags   = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    Service = var.PROJECT_SERVICE_TYPE
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
  policy     = templatefile("${path.module}/templates/s3-policy-t1.json", { BUCKET_NAME = var.BUCKET_NAME })
}
resource "aws_s3_bucket_website_configuration" "bucket-website-config" {
  bucket = aws_s3_bucket.s3-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "null_resource" "upload-to-s3" {
  depends_on = [aws_s3_bucket.s3-bucket]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
       AWS_ACCESS_KEY_ID=${var.AWS_ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${var.AWS_SECRET_KEY} AWS_REGION=${var.AWS_REGION} aws s3 cp ${var.SOURCE_PATH} s3://${var.BUCKET_NAME}/ --recursive
    EOF
  }
}
#resource "aws_s3_bucket_acl" "bucket-acl" {
#  depends_on = [aws_s3_bucket_policy.bucket-policy]
#  bucket = aws_s3_bucket.s3-bucket.id
#
#  acl = "public-read"
#}
#resource "aws_s3_object" "bucket-build-folder-upload" {
#  depends_on = [aws_s3_bucket_policy.bucket-policy]
#  for_each = fileset(var.SOURCE_PATH, "**")
#  bucket = aws_s3_bucket.s3-bucket.id
#  key = each.value
#  source = "${var.SOURCE_PATH}/${each.value}"
#  etag         = filemd5("${var.SOURCE_PATH}/${each.value}")
#  content_type = lookup(var.MIME_TYPES, regex("\\.[^.]+$", each.value), null)
#}