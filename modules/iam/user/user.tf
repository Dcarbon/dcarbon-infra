resource "aws_iam_user" "user" {
  name = var.NAME
  path = var.PATH
  force_destroy = var.FORCE_DESTROY

  tags = var.TAGS
}

resource "aws_iam_user_login_profile" "login-profile" {
  user    = aws_iam_user.user.name
}

resource "aws_iam_access_key" "access-key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user-policy" {
  name   = var.POLICY_NAME
  user   = aws_iam_user.user.name
  policy = var.POLICY
}

resource "aws_iam_policy" "user-policy-2" {
  count  = var.POLICY2 != null ? 1 : 0
  name        = "${var.POLICY_NAME}-2"
  policy      = var.POLICY2
}

resource "aws_iam_user_policy_attachment" "policy-attach" {
  count  = var.POLICY2 != null ? 1 : 0
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.user-policy-2[count.index].arn
}