data "aws_iam_policy_document" "cicd-deployment-policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:List*",
      "ecr:Get*",
      "ecr:Describe*",
      "ecr:List*",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["arn:aws:ecr:*:${module.current-account.current_account_id}:repository/${var.PROJECT_NAME}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:Get*",
      "ecs:List*",
      "ecs:Describe*",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:PutAttributes",
      "ecs:UpdateService",
      "ecs:UpdateTaskSet",
      "ecs:RegisterTaskDefinition",
      "ecs:TagResource"
    ]
    resources = [
      "arn:aws:ecs:*:${module.current-account.current_account_id}:service/${var.PROJECT_NAME}-*-cluster/${var.PROJECT_NAME}-*-service",
      "arn:aws:ecs:*:${module.current-account.current_account_id}:task-definition/${var.PROJECT_NAME}-*-td:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      "arn:aws:iam::${module.current-account.current_account_id}:role/${var.PROJECT_NAME}-*-ecs-task-execute",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Describe*",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:PutObject",
    ]
    resources = ["arn:aws:s3:::${var.PROJECT_NAME}-*-admin"]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = ["arn:aws:cloudfront::${module.current-account.current_account_id}:distribution/*"]
  }
}
data "aws_iam_policy_document" "cicd-deployment2-policy" {
  statement {
    effect = "Allow"
    actions = [
      "cloudformation:Describe*",
      "cloudformation:List*",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteStack",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:DeleteChangeSet"
    ]
    resources = [
      "arn:aws:cloudformation:${var.AWS_REGION}:${module.current-account.current_account_id}:stack/${var.PROJECT_NAME}-minting-*/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudformation:ValidateTemplate",
      "apigateway:POST",
      "apigateway:DELETE",
      "apigateway:GET",
      "apigateway:PATCH",
      "lambda:GetFunction",
      "apigateway:TagResource",
      "lambda:CreateEventSourceMapping",
      "lambda:GetEventSourceMapping"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = ["arn:aws:s3:::${var.PROJECT_NAME}-minting-*-serverlessdeploymentbucket-*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:*",
    ]
    resources = ["arn:aws:logs:${var.AWS_REGION}:${module.current-account.current_account_id}:log-group:/aws/lambda/${var.PROJECT_NAME}-minting-*-*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "lambda:*",
    ]
    resources = ["arn:aws:lambda:${var.AWS_REGION}:${module.current-account.current_account_id}:function:${var.PROJECT_NAME}-minting-*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = ["arn:aws:iam::${module.current-account.current_account_id}:role/${var.PROJECT_NAME}-*-lambda-minting-role"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
    ]
    resources = [
      "arn:aws:ssm:${var.AWS_REGION}:${module.current-account.current_account_id}:parameter/${var.PROJECT_NAME}/${var.ENV}/*"
    ]
  }
}
module "user-cicd" {
  source               = "../modules/iam/user"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.COMMON
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-cicd"
  POLICY_NAME          = "${var.PROJECT_NAME}-cicd-policy"
  POLICY               = data.aws_iam_policy_document.cicd-deployment-policy.json
  POLICY2               = data.aws_iam_policy_document.cicd-deployment2-policy.json
}