locals {
  source-path = "${path.module}/${var.SOURCE_PATH}"
}
resource "aws_s3_object" "object" {
  for_each = fileset(path.module, "${var.SOURCE_PATH}/*")

  bucket = var.BUCKET_ID
  key    = replace(each.value, "files/", var.KEY)
  source = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = lookup(var.MIME_TYPES, regex("\\.[^.]+$", each.value), null)
}