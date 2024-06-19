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
}