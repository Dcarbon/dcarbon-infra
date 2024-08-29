resource "aws_scheduler_schedule_group" "schedule-group" {
  name = var.NAME
  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}