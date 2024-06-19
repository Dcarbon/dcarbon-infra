locals {
  common-tags = {
    Terraform = "true"
    Prj       = var.PROJECT_NAME
    Env       = var.ENV
  }
}
module "current-account" {
  source = "../modules/account"
}