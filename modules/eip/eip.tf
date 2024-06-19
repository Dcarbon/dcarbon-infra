resource "aws_eip" "eip" {
  instance = var.INSTANCE
  domain   = "vpc"

  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}