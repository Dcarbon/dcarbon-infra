resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}-cluster"
  tags  = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}-ecs-cluster"
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}
resource "aws_ecs_service" "ecs_service" {
  depends_on = [aws_ecs_cluster.ecs_cluster]
  name = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}-service"
  launch_type = var.LAUNCH_TYPE
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = var.TASK_DEFINITION_ARN
  scheduling_strategy = var.SCHEDULING_STRATEGY
  desired_count = var.DESIRED_COUNT
  deployment_minimum_healthy_percent = var.D_MIN_HEALTHY_PERCENT
  deployment_maximum_percent = var.D_MAX_PERCENT
  wait_for_steady_state = var.WAIT_FOR_STEADY_STATE
  network_configuration {
    subnets = var.VPC_SUBNETS
    security_groups = var.ECS_SECURITY_GROUPS
    assign_public_ip = true
  }
  health_check_grace_period_seconds = var.HEALTH_CHECK_GRACE_PERIOD_SECONDS
  load_balancer {
    target_group_arn = var.TARGET_GROUP_ARN
    container_name = var.LB_CONTAINER_NAME
    container_port = var.LB_CONTAINER_PORT
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  tags  = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}-ecs-service"
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}