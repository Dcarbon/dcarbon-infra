data "aws_iam_policy_document" "ecs-task-assume-role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "ecs-task-execute" {
  name               = var.NAME
  description        = var.DESCRIPTION
  assume_role_policy = data.aws_iam_policy_document.ecs-task-assume-role.json
  inline_policy {
    name = "AmazonCloudWatchCreateLogGroupRolePolicy"
    policy = var.POLICY
  }
  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}
resource "aws_iam_role_policy_attachment" "ecs-task-execute-role-attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs-task-execute.name
}