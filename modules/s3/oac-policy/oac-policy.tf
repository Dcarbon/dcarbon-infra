data "aws_iam_policy_document" "s3-bucket-policy" {
  statement {
    actions = [ "s3:GetObject" ]
    resources = [ var.PUBLIC_GET_RESOURCE ]
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [var.CLOUDFRONT_ARN]
    }
  }

  statement {
    actions = [
      "s3:*Object*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    resources = var.ACCESS_RESOURCES
    principals {
      type = "AWS"
      identifiers = var.ACCESS_RESOURCES_IDENTIFIERS
    }
  }

  statement {
    actions = [
      "s3:*"
    ]
    resources = [var.PUBLIC_GET_RESOURCE]
    principals {
      type = "AWS"
      identifiers = var.FULL_ACCESS_PUBLIC_RESOURCES_IDENTIFIERS
    }
  }
}

resource "aws_s3_bucket_policy" "cdn-oac-bucket-policy" {
  bucket = var.BUCKET_ID
  policy = data.aws_iam_policy_document.s3-bucket-policy.json
}