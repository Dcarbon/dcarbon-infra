locals {
  minting-scheduler-group   = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.MINTING}"
  minting-lambda-arn-prefix = "arn:aws:lambda:${var.AWS_REGION}:${module.current-account.current_account_id}:function:${var.PROJECT_NAME}-${var.PROJECT_SERVICES.MINTING}-${var.ENV}"
}
data "aws_iam_policy_document" "scheduler-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      values = [module.current-account.current_account_id]
      variable = "aws:SourceAccount"
    }
  }
}
module "minting-scheduler-iam" {
  source               = "../modules/iam"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.MINTING
  TAGS                 = local.common-tags
  ROLE_NAME            = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.MINTING}-scheduler-role"
  ROLE_DESCRIPTION     = "IAM Role for ${var.PROJECT_SERVICES.MINTING} scheduler"
  ASSUME_ROLE_POLICY   = data.aws_iam_policy_document.scheduler-assume-role.json
  INLINE_POLICY = [
    {
      name : "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.MINTING}-scheduler-policy",
      policy : jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Action" : [
              "sqs:SendMessage"
            ],
            "Resource" : [
              module.minting-trigger-queue.queue-arn
            ],
            "Effect" : "Allow"
          }
        ]
      })
    }
  ]
}
module "minting-scheduler-group" {
  source               = "../modules/event-bridge/scheduler/group"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.MINTING
  TAGS                 = local.common-tags
  NAME                 = local.minting-scheduler-group
}
module "minting-daily-trigger-schedule" {
  source               = "../modules/event-bridge/scheduler"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.MINTING
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.ENV}-minting-daily-trigger"
  GROUP_NAME           = local.minting-scheduler-group
  SCHEDULE_EXPRESSION  = "cron(40 8 * * ? *)"
  TARGET_ARN           = module.minting-trigger-queue.queue-arn
  TARGET_ROLE_ARN      = module.minting-scheduler-iam.iam-role-arn
  SQS_MESSAGE_GROUP_ID = "${var.PROJECT_NAME}-${var.ENV}-daily-trigger"
  TARGET_INPUT = jsonencode({
    minting_schedule : "daily"
  })
}

module "minting-weekly-trigger-schedule" {
  source               = "../modules/event-bridge/scheduler"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.MINTING
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.ENV}-minting-weekly-trigger"
  GROUP_NAME           = local.minting-scheduler-group
  SCHEDULE_EXPRESSION  = "cron(45 8 * * ? *)"
  TARGET_ARN           = module.minting-trigger-queue.queue-arn
  TARGET_ROLE_ARN      = module.minting-scheduler-iam.iam-role-arn
  SQS_MESSAGE_GROUP_ID = "${var.PROJECT_NAME}-${var.ENV}-weekly-trigger"
  TARGET_INPUT = jsonencode({
    minting_schedule : "weekly"
  })
}


module "minting-monthly-trigger-schedule" {
  source               = "../modules/event-bridge/scheduler"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.MINTING
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.ENV}-minting-monthly-trigger"
  GROUP_NAME           = local.minting-scheduler-group
  SCHEDULE_EXPRESSION  = "cron(50 8 * * ? *)"
  TARGET_ARN           = module.minting-trigger-queue.queue-arn
  TARGET_ROLE_ARN      = module.minting-scheduler-iam.iam-role-arn
  SQS_MESSAGE_GROUP_ID = "${var.PROJECT_NAME}-${var.ENV}-monthly-trigger"
  TARGET_INPUT = jsonencode({
    minting_schedule : "monthly"
  })
}

module "minting-yearly-trigger-schedule" {
  source               = "../modules/event-bridge/scheduler"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.MINTING
  TAGS                 = local.common-tags
  NAME                 = "${var.PROJECT_NAME}-${var.ENV}-minting-yearly-trigger"
  GROUP_NAME           = local.minting-scheduler-group
  SCHEDULE_EXPRESSION  = "cron(5 9 * * ? *)"
  TARGET_ARN           = module.minting-trigger-queue.queue-arn
  TARGET_ROLE_ARN      = module.minting-scheduler-iam.iam-role-arn
  SQS_MESSAGE_GROUP_ID = "${var.PROJECT_NAME}-${var.ENV}-yearly-trigger"
  TARGET_INPUT = jsonencode({
    minting_schedule : "yearly"
  })
}