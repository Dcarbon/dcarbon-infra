resource "aws_ssm_parameter" "main" {
  for_each = var.ENV_LIST

  name        = each.value.name
  description = each.value.description
  type        = each.value.type
  value       = each.value.value

  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}