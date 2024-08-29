resource "aws_secretsmanager_secret_policy" "policy" {
  secret_arn = var.SECRET_ARN
  policy     = var.POLICY
}