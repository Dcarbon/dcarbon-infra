resource "aws_ecs_task_definition" "main-task-definition" {
  family                   = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}-td"
  execution_role_arn       = var.ECS_TASK_EXECUTE_ROLE_ARN
  memory                   = var.TASK_MEMORY_SIZE
  task_role_arn            = var.ECS_TASK_EXECUTE_ROLE_ARN
  requires_compatibilities = var.REQUIRES_COMPATIBILITIES
  network_mode             = "awsvpc"
  runtime_platform {
    cpu_architecture = var.RUNTIME_PLATFORM.cpu_architecture
    operating_system_family = var.RUNTIME_PLATFORM.operating_system_family
  }
  cpu                      = var.CPU_SIZE
  container_definitions    = templatefile("${path.module}/templates/tmp1.json.tpl", {
    TASK_FAMILY = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    REGION      = var.AWS_REGION
    PORT        = var.CONTAINER_PORT_MAPPING
    ENVIRONMENT = jsonencode(var.CONTAINER_ENVIRONMENT)
    IMAGE       = var.ECR_IMAGE_URL
    CONTAINER_NAME = var.CONTAINER_NAME
  })
  tags = merge({
    Name = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}-td"
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}