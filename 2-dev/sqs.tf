module "minting-trigger-queue" {
  source                        = "../modules/sqs/fifo"
  PROJECT_NAME                  = var.PROJECT_NAME
  ENV                           = var.ENV
  PROJECT_SERVICE_TYPE          = var.PROJECT_SERVICES.MINTING
  TAGS                          = local.common-tags
  NAME                          = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.MINTING}-trigger"
  VISIBILITY_TIMEOUT_SECONDS    = 605
  VISIBILITY_TIMEOUT_SECONDS_DL = 600
  MESSAGE_RETENTION_SECONDS_DL  = 1209600
  MAX_RECEIVE_COUNT             = 3
  POLICY_STATEMENT = {
    "aws_user" = {
      "actions" : ["sqs:*"],
      "principals" : {
        type = "AWS"
        identifiers = [module.current-account.current_account_arn]
      }
    }
  }
  POLICY_STATEMENT_CONDITION = {
    "scheduler" = {
      "actions" : ["sqs:SendMessage"],
      "principals" : {
        type = "Service"
        identifiers = ["scheduler.amazonaws.com"]
      },
      "condition" : {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values = [
          "arn:aws:scheduler:${var.AWS_REGION}:${module.current-account.current_account_id}:schedule/${local.minting-scheduler-group}/*"
        ]
      }
    }
  }
}

module "minting-queue" {
  source                        = "../modules/sqs/fifo"
  PROJECT_NAME                  = var.PROJECT_NAME
  ENV                           = var.ENV
  PROJECT_SERVICE_TYPE          = var.PROJECT_SERVICES.MINTING
  TAGS                          = local.common-tags
  NAME                          = "${var.PROJECT_NAME}-${var.ENV}-minting"
  VISIBILITY_TIMEOUT_SECONDS    = 905
  VISIBILITY_TIMEOUT_SECONDS_DL = 900
  MESSAGE_RETENTION_SECONDS_DL  = 1209600
  MAX_RECEIVE_COUNT             = 3
  POLICY_STATEMENT = {
    "aws_user" = {
      "actions" : ["sqs:*"],
      "principals" : {
        type = "AWS"
        identifiers = [module.current-account.current_account_arn]
      }
    }
  }
  POLICY_STATEMENT_CONDITION = {
    "scheduler" = {
      "actions" : ["sqs:SendMessage"],
      "principals" : {
        type = "Service"
        identifiers = ["scheduler.amazonaws.com"]
      },
      "condition" : {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values = [
          "arn:aws:scheduler:${var.AWS_REGION}:${module.current-account.current_account_id}:schedule/${local.minting-scheduler-group}/*"
        ]
      }
    }
  }
}