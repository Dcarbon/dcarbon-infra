resource "aws_wafv2_web_acl" "web-acl" {
  name        = var.NAME
  description = var.DESCRIPTION
  scope              = var.SCOPE

  default_action {
    block {}
  }

  rule {
    name     = var.IP_SET_RULE_NAME
    priority = 1

    action {
      allow {}
    }

    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = var.IP_SET_ARN
          }
        }
        statement {
          ip_set_reference_statement {
            arn = var.IP_SET_V6_ARN
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  tags = var.TAGS

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "metric-name"
    sampled_requests_enabled   = false
  }
}