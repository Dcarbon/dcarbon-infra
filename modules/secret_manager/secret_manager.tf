resource "aws_secretsmanager_secret" "secretsmanager" {
  name = var.NAME

  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}

resource "aws_secretsmanager_secret_version" "version" {
  secret_id     = aws_secretsmanager_secret.secretsmanager.id
  secret_string = var.SECRET
}