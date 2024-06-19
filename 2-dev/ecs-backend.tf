locals {
  ecr-image-tag = "latest"
  task-definition-container-ports = {
    default : 80
  }
  backend = {
    task-definition-container-name : "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.BACKEND}-container",
    target-group-health-check-path = "/v1/common/health-check"
  }
}
module "backend-ecr" {
  source                = "../modules/ecr"
  depends_on = [module.current-account]
  AWS_ACCOUNT_ID        = module.current-account.current_account_id
  ENV                   = var.ENV
  PROJECT_NAME          = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE  = var.PROJECT_SERVICES.BACKEND
  AWS_REGION            = var.AWS_REGION
  AWS_ACCESS_KEY        = var.AWS_ACCESS_KEY
  AWS_SECRET_KEY        = var.AWS_SECRET_KEY
  FORCE_DELETE          = true
  CREATE_REPOSITORY_FLG = true
  BUILD_IMAGE_FLG       = false
  TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.BACKEND })
}
module "backend-task-definition" {
  source = "../modules/task-definition"
  depends_on = [
    module.current-account, module.common-role, module.backend-ecr
  ]
  AWS_ACCOUNT_ID            = module.current-account.current_account_id
  ENV                       = var.ENV
  PROJECT_NAME              = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE      = var.PROJECT_SERVICES.BACKEND
  AWS_REGION                = var.AWS_REGION
  ECS_TASK_EXECUTE_ROLE_ARN = module.common-role.ecs-task-execute-role-arn
  TASK_MEMORY_SIZE          = "1024"
  REQUIRES_COMPATIBILITIES = ["FARGATE"]
  CPU_SIZE                  = "512"
  CONTAINER_PORT_MAPPING    = local.task-definition-container-ports.default
  ECR_IMAGE_URL             = "${module.backend-ecr.ecr-repository-url}:${local.ecr-image-tag}"
  CONTAINER_NAME            = local.backend.task-definition-container-name
  CONTAINER_ENVIRONMENT = [
    {
      name : "PORT",
      value : "80"
    }
  ]
  TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.BACKEND })
}

module "backend-discovery-service" {
  depends_on = [module.main-cloud-map]
  source               = "../modules/cloudmap/discovery-service"
  ENV                  = var.ENV
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND
  TAGS                 = local.common-tags
  NAMESPACE_ID         = module.main-cloud-map.cloudmap-id
  DNS_RECORDS = {
    "1" : {
      ttl : 15,
      type : "SRV"
    }
  }
  DISCOVERY_SERVICE_NAME = var.PROJECT_SERVICES.BACKEND
}

module "backend-ecs-service" {
  depends_on = [module.backend-task-definition]
  source                = "../modules/ecs/ecs-cloudmap"
  ENV                   = var.ENV
  PROJECT_NAME          = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE  = var.PROJECT_SERVICES.BACKEND
  TASK_DEFINITION_ARN   = module.backend-task-definition.task-definition-arn
  DESIRED_COUNT         = 1
  VPC_SUBNETS           = var.VPC.PUBLIC_SUBNETS
  ECS_SECURITY_GROUPS = [module.common-ecs-security-group.security-group-id]
  REGISTRY_ARN          = module.backend-discovery-service.discovery-service-arn
  D_MIN_HEALTHY_PERCENT = 50
  D_MAX_PERCENT         = 200
  TAGS = merge({
    Schedule : var.ENV == "dev" ? "on" : "off"
  }, local.common-tags)
  WAIT_FOR_STEADY_STATE = true
}
