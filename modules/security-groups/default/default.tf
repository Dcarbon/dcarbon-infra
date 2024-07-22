resource "aws_default_security_group" "default" {
  vpc_id      = var.VPC_ID
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name    = var.SECURITY_GROUP_NAME
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}