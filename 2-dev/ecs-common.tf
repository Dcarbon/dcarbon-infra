module "common-ecs-security-group" {
  source                     = "../modules/security-groups"
  PROJECT_SERVICE_TYPE       = var.PROJECT_SERVICES.COMMON
  SECURITY_GROUP_NAME        = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.COMMON}-ecs-sg"
  SECURITY_GROUP_DESCRIPTION = "(${var.ENV}) This Security Group use for ecs service of ${var.PROJECT_NAME} ${var.PROJECT_SERVICES.COMMON}"
  VPC_ID                     = var.VPC.ID
  SECURITY_GROUP_INBOUNDS = {
    (local.task-definition-container-ports.default) : {
      "description" : "Public for services of VPC",
      "cidr_blocks" : [var.VPC.CIDR_BLOCK]
      "security_groups" : [],
      "from_port" : local.task-definition-container-ports.default,
      "to_port" : local.task-definition-container-ports.default,
      "protocol" : "tcp"
    }
  }
  TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.COMMON })
}