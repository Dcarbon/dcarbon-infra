module "vpc-security-group-id" {
  depends_on = [module.common-ecs-security-group.security-group-id]
  source                     = "../modules/security-groups"
  PROJECT_SERVICE_TYPE       = var.PROJECT_SERVICES.COMMON
  SECURITY_GROUP_NAME        = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.COMMON}-vpc-group-sg"
  SECURITY_GROUP_DESCRIPTION = "(${var.ENV}) This Security Group use for database of ${var.PROJECT_NAME} ${var.PROJECT_SERVICES.COMMON}"
  VPC_ID                     = var.VPC.ID
  SECURITY_GROUP_INBOUNDS = {
    "5432" : {
      "description" : "Public access: Ecs Service, VPC"
      "cidr_blocks" : concat(var.IP_WHITE_LIST, [var.VPC.CIDR_BLOCK])
      "from_port" : 5432,
      "to_port" : 5432,
      "security_groups" : [module.common-ecs-security-group.security-group-id]
      "protocol" : "tcp"
    }
  }
  TAGS = local.common-tags
}
module "postgres-db" {
  source               = "../modules/rds/postgres"
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.COMMON
  TAGS = merge(local.common-tags, {
    schedule = "on"
  })
  INSTANCE_CLASS                 = "db.t3.micro"
  DB_NAME                        = var.PROJECT_NAME
  IDENTIFIER                     = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.COMMON}"
  USERNAME                       = var.DATABASE_ADMIN_AUTH.username
  PASSWORD                       = var.DATABASE_ADMIN_AUTH.password
  BACKUP_RETENTION_PERIOD        = 0
  PUBLICLY_ACCESSIBLE            = true
  DELETION_PROTECTION            = false
  VPC_SECURITY_GROUP_IDS = [module.vpc-security-group-id.security-group-id]
  SKIP_FINAL_SNAPSHOT            = true
  SUBNET_IDS                     = var.VPC.PUBLIC_SUBNETS
  SUBNET_NAME                    = "${var.PROJECT_NAME}-${var.ENV}-db-public-subnets-group"
  PARAMETER_GROUP_NAME_CUSTOMIZE = "${var.PROJECT_NAME}-${var.ENV}-posgres-p-group"
  PARAMETER_GROUP_FAMILY         = "postgres16"
  PARAMETER_GROUP_PARAMETERS = {
    FORCE_SSL : {
      name : "rds.force_ssl"
      value : "0"
    }
  }
}
module "postgres-db-create-owner-user" {
  depends_on = [module.postgres-db]
  source            = "../modules/scripts/rds"
  DB_HOST           = module.postgres-db.postgres-db-address
  DB_NAME           = module.postgres-db.postgres-db-name
  DB_USERNAME       = module.postgres-db.postgres-db-username
  DB_PASSWORD       = module.postgres-db.postgres-db-password
  DB_USERNAME_OWNER = var.DATABASE_OWNER_AUTH.username
  DB_PASSWORD_OWNER = var.DATABASE_OWNER_AUTH.password
}