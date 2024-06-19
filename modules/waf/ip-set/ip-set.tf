resource "aws_wafv2_ip_set" "ip-set" {
  name               = var.NAME
  description        = var.DESCRIPTION
  scope              = var.SCOPE
  ip_address_version = var.IP_ADDRESS_VERSION
  addresses          = var.ADDRESSES

  tags          = var.TAGS
}