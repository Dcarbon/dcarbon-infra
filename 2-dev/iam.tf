data "aws_iam_policy_document" "lambda-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "user-application-policy" {
  statement {
    effect = "Allow"
    actions = ["appsync:GraphQL"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "appsync:ListDataSources",
      "appsync:ListGraphqlApis",
      "appsync:CreateApiKey",
      "appsync:ListFunctions",
      "appsync:ListApiKeys",
      "appsync:ListDomainNames",
      "appsync:ListResolvers"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunctionUrl",
      "lambda:InvokeFunction",
      "lambda:InvokeAsync"
    ]
    resources = [
      "arn:aws:lambda:*:${module.current-account.current_account_id}:function:${var.PROJECT_NAME}-*-${var.ENV}-*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Describe*",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:PostObject",
      "s3:DeleteObjectVersion",
      "s3:RestoreObject"
    ]
    resources = [module.common-upload-bucket.s3-bucket-arn]
  }
  statement {
    effect  = "Allow"
    actions = [
      "ses:SendEmail"
    ]
    resources = ["arn:aws:ses:${var.AWS_REGION}:${module.current-account.current_account_id}:identity/*"]
  }
}
module "user-application" {
  source               = "../modules/iam/user"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.COMMON
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.ENV}-application"
  POLICY_NAME          = "${var.PROJECT_NAME}-${var.ENV}-application-policy"
  POLICY               = data.aws_iam_policy_document.user-application-policy.json
}