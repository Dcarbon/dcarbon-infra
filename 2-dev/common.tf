locals {
  common-tags = {
    terraform = "true"
    prj       = var.PROJECT_NAME
    env       = var.ENV
    cus       = var.PROJECT_NAME
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
  AWS_REGION           = var.AWS_REGION
  AWS_ACCOUNT_ID       = module.current-account.current_account_id
}