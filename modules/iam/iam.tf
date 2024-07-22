resource "aws_iam_role" "main-iam-role" {
  name               = var.ROLE_NAME
  description        = var.ROLE_DESCRIPTION
  assume_role_policy = var.ASSUME_ROLE_POLICY

  dynamic "inline_policy" {
    for_each = var.INLINE_POLICY
    content {
      name   = lookup(inline_policy.value, "name")
      policy = lookup(inline_policy.value, "policy")
    }
  }
  tags = merge({
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}
resource "aws_iam_role_policy_attachment" "main-iam-role-attach" {
  count      = var.ATTACK_POLICY_ARN != null ? 1 : 0
  policy_arn = var.ATTACK_POLICY_ARN
  role       = aws_iam_role.main-iam-role.name
}