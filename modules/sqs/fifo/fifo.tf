resource "aws_sqs_queue" "queue" {
  name                        = "${var.NAME}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = var.VISIBILITY_TIMEOUT_SECONDS
  message_retention_seconds   = var.MESSAGE_RETENTION_SECONDS
  delay_seconds               = var.DELAY_SECONDS
  max_message_size            = var.MAX_MESSAGE_SIZE
  receive_wait_time_seconds   = var.RECEIVE_WAIT_TIME_SECONDS
  deduplication_scope         = var.DEDUPLICATION_SCOPE
  fifo_throughput_limit       = var.FIFO_THROUGHPUT_LIMIT
  sqs_managed_sse_enabled = var.SQS_MANAGED_SSE_ENABLED
  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}
data "aws_iam_policy_document" "queue-policy" {
  dynamic "statement" {
    for_each = var.POLICY_STATEMENT
    content {
      effect = "Allow"
      principals {
        type = lookup(lookup(statement.value, "principals"), "type")
        identifiers = lookup(lookup(statement.value, "principals"), "identifiers")
      }
      actions     = lookup(statement.value, "actions")
      resources = [aws_sqs_queue.queue.arn]
    }
  }

  dynamic "statement" {
    for_each = var.POLICY_STATEMENT_CONDITION
    content {
      effect = "Allow"
      principals {
        type = lookup(lookup(statement.value, "principals"), "type")
        identifiers = lookup(lookup(statement.value, "principals"), "identifiers")
      }
      actions     = lookup(statement.value, "actions")
      resources = [aws_sqs_queue.queue.arn]
      condition {
        test = lookup(lookup(statement.value, "condition"), "test")
        variable = lookup(lookup(statement.value, "condition"), "variable")
        values = lookup(lookup(statement.value, "condition"), "values")
      }
    }
  }
}
resource "aws_sqs_queue_policy" "queue-policy" {
  queue_url = aws_sqs_queue.queue.id
  policy    = data.aws_iam_policy_document.queue-policy.json
}