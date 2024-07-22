resource "aws_db_subnet_group" "db-subnet-group" {
  name       = var.SUBNET_NAME
  subnet_ids = var.SUBNET_IDS

  tags = merge({
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}

resource "aws_db_parameter_group" "db-parameter-group" {
  name   = var.PARAMETER_GROUP_NAME_CUSTOMIZE
  family = var.PARAMETER_GROUP_FAMILY
  dynamic "parameter" {
    for_each = var.PARAMETER_GROUP_PARAMETERS
    content {
      name = lookup(parameter.value, "name")
      value = lookup(parameter.value, "value")
    }
  }

  tags = merge({
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}

resource "aws_db_instance" "postgres-rds" {
  identifier                   = var.IDENTIFIER
  instance_class               = var.INSTANCE_CLASS
  engine                       = "postgres"
  engine_version               = var.ENGINE_VERSION
  multi_az                     = var.MULTI_AZ
  db_name                      = var.DB_NAME
  username                     = var.USERNAME
  password                     = var.PASSWORD
  storage_type                 = var.STORAGE_TYPE
  allocated_storage            = var.ALLOCATED_STORAGE
  max_allocated_storage        = var.MAX_ALLOCATED_STORAGE
  network_type                 = var.NETWORK_TYPE
  vpc_security_group_ids       = var.VPC_SECURITY_GROUP_IDS
  db_subnet_group_name         = aws_db_subnet_group.db-subnet-group.id
  performance_insights_enabled = var.PERFORMANCE_INSIGHTS_ENABLED
  parameter_group_name         = aws_db_parameter_group.db-parameter-group.name
  option_group_name            = var.OPTION_GROUP_NAME
  backup_retention_period      = var.BACKUP_RETENTION_PERIOD
  publicly_accessible          = var.PUBLICLY_ACCESSIBLE
  deletion_protection          = var.DELETION_PROTECTION
  skip_final_snapshot          = var.SKIP_FINAL_SNAPSHOT

  tags = merge({
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}