locals {
  common-tags = {
    Terraform = "true"
    Prj       = var.PROJECT_NAME
    Env       = var.ENV
  }
  mime_types = jsondecode(file("${path.module}/../modules/s3/utils/mime.json"))
}
module "current-account" {
  source = "../modules/account"
}
module "common-role" {
  source               = "../modules/iam/common"
  ENV                  = var.ENV
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = "amd"
  TAGS                 = local.common-tags
  BUILD_RESOURCE = ["ECS", "APPSYNC"]
}