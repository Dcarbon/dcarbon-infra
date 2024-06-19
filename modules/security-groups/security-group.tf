resource "aws_security_group" "security-group" {
  name = var.SECURITY_GROUP_NAME
  description = var.SECURITY_GROUP_DESCRIPTION
  vpc_id = var.VPC_ID
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = var.SECURITY_GROUP_INBOUNDS
    content {
      from_port   = lookup(ingress.value, "from_port")
      to_port     = lookup(ingress.value, "to_port")
      protocol    = lookup(ingress.value, "protocol")
      cidr_blocks = lookup(ingress.value, "cidr_blocks")
      security_groups = lookup(ingress.value, "security_groups")
      description = lookup(ingress.value, "description")
    }
  }
  tags = merge({
    Name = var.SECURITY_GROUP_NAME
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}