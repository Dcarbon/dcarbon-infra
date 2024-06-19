# module "backend-admin-ecr" {
#   source                = "../modules/ecr"
#   depends_on = [module.current-account]
#   AWS_ACCOUNT_ID        = module.current-account.current_account_id
#   ENV                   = var.ENV
#   PROJECT_NAME          = var.PROJECT_NAME
#   PROJECT_SERVICE_TYPE  = var.PROJECT_SERVICES.BACKEND_ADMIN
#   AWS_REGION            = var.AWS_REGION
#   AWS_ACCESS_KEY        = var.AWS_ACCESS_KEY
#   AWS_SECRET_KEY        = var.AWS_SECRET_KEY
#   FORCE_DELETE          = true
#   CREATE_REPOSITORY_FLG = true
#   BUILD_IMAGE_FLG       = true
#   IMAGE_FILE_PATH       = "${path.cwd}/../../${var.PROJECT_NAME_REPOSITORY}-${var.PROJECT_SERVICES.BACKEND_ADMIN}"
#   TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.BACKEND_ADMIN })
# }
# module "backend-admin-task-definition" {
#   source = "../modules/task-definition"
#   depends_on = [
#     module.current-account, module.common-role, module.backend-admin-ecr
#   ]
#   AWS_ACCOUNT_ID            = module.current-account.current_account_id
#   ENV                       = var.ENV
#   PROJECT_NAME              = var.PROJECT_NAME
#   PROJECT_SERVICE_TYPE      = var.PROJECT_SERVICES.BACKEND_ADMIN
#   AWS_REGION                = var.AWS_REGION
#   ECS_TASK_EXECUTE_ROLE_ARN = module.common-role.ecs-task-execute-role-arn
#   TASK_MEMORY_SIZE          = "1024"
#   REQUIRES_COMPATIBILITIES = ["FARGATE"]
#   CPU_SIZE                  = "512"
#   CONTAINER_PORT_MAPPING    = local.task-definition-container-ports.default
#   ECR_IMAGE_URL             = "${module.backend-admin-ecr.ecr-repository-url}:${local.ecr-image-tag}"
#   CONTAINER_NAME            = local.backend-admin.task-definition-container-name
#   CONTAINER_ENVIRONMENT = concat(var.ADMIN_BACKEND_ENV, [
#     {
#       name : "BASE_URL",
#       value : "https://${local.backend-admin-domain}"
#     },
#     {
#       name : "ADMIN_URL",
#       value : "https://${local.admin-domain-name}"
#     },
#     {
#       name : "SWAGGER_ENABLE",
#       value : var.ENV == "dev" ? true : false
#     },
#     {
#       name : "STAGE",
#       value : var.ENV == "dev"
#     },
#     {
#       name : "LAMBDA_SNAPHOT_NOTIFICATION_ARN",
#       value : "arn:aws:lambda:${var.AWS_REGION}:${module.current-account.current_account_id}:function:${var.PROJECT_NAME}-${var.PROJECT_SERVICES.SNAPSHOT_SORT}-${var.ENV}-notification"
#     },
#     {
#       name : "SQS_NFT_SNAPHOT_ARN",
#       value : module.snapshot-queue.queue-arn
#     },
#     {
#       name : "AWS_SNAPSHOT_SCHEDULER_ROLE_ARN",
#       value : module.snapshot-scheduler-iam.iam-role-arn
#     }, {
#       name : "AWS_SNAPSHOT_GROUP_NAME",
#       value : local.snapshot-scheduler-group
#     },
#     {
#       name : "SQS_CATNIP_ASSET_SNAPSHOT_ARN",
#       value : module.snapshot-catnip-assets-queue.queue-url
#     },
#     {
#       name : "ALLOWED_ORIGINS",
#       value : var.ENV =="prod" ? "https://admin.${var.CERT_DOMAIN}" :
#         "http://localhost:3000,https://${var.ENV}-admin.${var.CERT_DOMAIN}"
#     },
#   ])
#   TAGS = merge(local.common-tags, { Service : var.PROJECT_SERVICES.BACKEND_ADMIN })
# }
#
# module "backend-admin-discovery-service" {
#   depends_on = [module.main-cloud-map]
#   source               = "../modules/cloudmap/discovery-service"
#   ENV                  = var.ENV
#   PROJECT_NAME         = var.PROJECT_NAME
#   PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_ADMIN
#   TAGS                 = local.common-tags
#   NAMESPACE_ID         = module.main-cloud-map.cloudmap-id
#   DNS_RECORDS = {
#     "1" : {
#       ttl : 15,
#       type : "SRV"
#     }
#   }
#   DISCOVERY_SERVICE_NAME = var.PROJECT_SERVICES.BACKEND_ADMIN
# }
#
# module "backend-admin-ecs-service" {
#   depends_on = [module.backend-admin-task-definition]
#   source                = "../modules/ecs/ecs-cloudmap"
#   ENV                   = var.ENV
#   PROJECT_NAME          = var.PROJECT_NAME
#   PROJECT_SERVICE_TYPE  = var.PROJECT_SERVICES.BACKEND_ADMIN
#   TASK_DEFINITION_ARN   = module.backend-admin-task-definition.task-definition-arn
#   DESIRED_COUNT         = 1
#   VPC_SUBNETS           = var.VPC.PUBLIC_SUBNETS
#   ECS_SECURITY_GROUPS = [module.common-ecs-security-group.security-group-id]
#   REGISTRY_ARN          = module.backend-admin-discovery-service.discovery-service-arn
#   D_MIN_HEALTHY_PERCENT = 50
#   D_MAX_PERCENT         = 200
#   TAGS = merge({
#     Schedule : var.ENV == "dev" ? "on" : "off"
#   }, local.common-tags)
#   WAIT_FOR_STEADY_STATE = true
# }