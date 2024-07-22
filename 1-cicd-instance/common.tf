locals {
  common-tags = {
    terraform = "true"
    prj       = var.PROJECT_NAME
    env       = var.ENV
    cus       = var.PROJECT_NAME
  }
}
module "current-account" {
  source = "../modules/account"
}