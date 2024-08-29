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
module "lambda-minting-iam" {
  source               = "../modules/iam"
  PROJECT_SERVICE_TYPE = ""
  TAGS                 = local.common-tags
  ROLE_NAME            = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.MINTING}-role"
  ROLE_DESCRIPTION     = "IAM Role for search minting lambda"
  ASSUME_ROLE_POLICY   = data.aws_iam_policy_document.lambda-assume-role.json
  INLINE_POLICY = [
    {
      name : "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.MINTING}-policy",
      policy : jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Action" : [
              "logs:CreateLogStream",
              "logs:CreateLogGroup",
              "logs:TagResource"
            ],
            "Resource" : [
              "arn:aws:logs:${var.AWS_REGION}:${module.current-account.current_account_id}:log-group:/aws/lambda/*"
            ],
            "Effect" : "Allow"
          },
          {
            "Action" : [
              "logs:PutLogEvents"
            ],
            "Resource" : [
              "arn:aws:logs:${var.AWS_REGION}:${module.current-account.current_account_id}:log-group:/aws/lambda/*"
            ],
            "Effect" : "Allow"
          },
          {
            "Action" : [
              "s3:*Object*",
              "s3:GetBucket*",
              "s3:List*"
            ],
            "Resource" : "arn:aws:s3:::${local.s3-common-bucket-name}/*",
            "Effect" : "Allow"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:DescribeNetworkInterfaces",
              "ec2:CreateNetworkInterface",
              "ec2:DeleteNetworkInterface",
              "ec2:DescribeInstances",
              "ec2:AttachNetworkInterface"
            ],
            "Resource" : "*"
          }, {
            "Effect" : "Allow",
            "Action" : [
              "secretsmanager:GetSecretValue",
            ],
            "Resource" : [
              "arn:aws:secretsmanager:${var.AWS_REGION}:${module.current-account.current_account_id}:secret:${var.PROJECT_NAME}/${var.ENV}/mint_signer/*",
              "arn:aws:secretsmanager:${var.AWS_REGION}:${module.current-account.current_account_id}:secret:${var.PROJECT_NAME}/${var.ENV}/arweave_secret"
            ]
          }, {
            "Effect" : "Allow",
            "Action" : [
              "ssm:GetParameters",
              "ssm:GetParameter",
              "ssm:PutParameter"
            ],
            "Resource" : [
              "arn:aws:ssm:${var.AWS_REGION}:${module.current-account.current_account_id}:parameter/${var.PROJECT_NAME}/${var.ENV}/*"
            ]
          },
          {
            "Action" : [
              "sqs:*"
            ],
            "Resource" : [module.minting-trigger-queue.queue-arn, module.minting-queue.queue-arn],
            "Effect" : "Allow"
          },
        ]
      })
    }
  ]
}