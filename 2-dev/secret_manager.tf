module "arweave-secret" {
  source               = "../modules/secret_manager"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.COMMON
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}/${var.ENV}/arweave_secret"
  SECRET = jsonencode(var.ARWEAVE_SECRET)
}
data "aws_iam_policy_document" "arweave-secret-policy" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS" //FIXME: dev only
      identifiers = [module.user-application.user-arn]
    }

    actions = ["secretsmanager:GetSecretValue"]
    resources = [module.arweave-secret.secret-arn]
  }

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [module.common-role.ecs-task-execute-role-arn, module.backend-admin-ecs-task-execute-role.role-arn]
    }

    actions = ["secretsmanager:GetSecretValue"]
    resources = [module.arweave-secret.secret-arn]
  }

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [module.lambda-minting-iam.iam-role-arn]
    }

    actions = ["secretsmanager:GetSecretValue"]
    resources = [module.arweave-secret.secret-arn]
  }
}
module "arweave-secret-policy" {
  depends_on = [module.arweave-secret]
  source     = "../modules/secret_manager/policy"
  POLICY     = data.aws_iam_policy_document.arweave-secret-policy.json
  SECRET_ARN = module.arweave-secret.secret-arn
}
