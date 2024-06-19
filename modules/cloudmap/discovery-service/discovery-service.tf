resource "aws_service_discovery_service" "discovery-service" {
  name = var.DISCOVERY_SERVICE_NAME

  dns_config {
    namespace_id = var.NAMESPACE_ID

    dynamic "dns_records" {
      for_each = var.DNS_RECORDS
      content {
        ttl  = lookup(dns_records.value, "ttl")
        type = lookup(dns_records.value, "type")
      }
    }
  }

  tags = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}