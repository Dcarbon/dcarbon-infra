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