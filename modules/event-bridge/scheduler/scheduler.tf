resource "aws_scheduler_schedule" "scheduler" {
  name = var.NAME

  flexible_time_window {
    mode = var.FLEXIBLE_TIME_WINDOW_MODE
  }

  schedule_expression = var.SCHEDULE_EXPRESSION

  group_name = var.GROUP_NAME

  target {
    arn      = var.TARGET_ARN
    role_arn = var.TARGET_ROLE_ARN
    retry_policy {
      maximum_event_age_in_seconds = var.MAXIMUM_EVENT_AGE_IN_SECONDS
      maximum_retry_attempts       = var.MAXIMUM_RETRY_ATTEMPTS
    }
    input = var.TARGET_INPUT
    sqs_parameters {
      message_group_id = var.SQS_MESSAGE_GROUP_ID
    }
  }
}