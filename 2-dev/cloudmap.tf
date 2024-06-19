locals {
  namespace = "${var.PROJECT_NAME}-${var.ENV}-local"
}
module "main-cloud-map" {
  source         = "../modules/cloudmap"
  NAMESPACE_NAME = "${var.PROJECT_NAME}-${var.ENV}-local"
  ENV            = var.ENV
  PROJECT_NAME   = var.PROJECT_NAME
  TAGS           = local.common-tags
  DESCRIPTION    = "Cloud map for ${var.PROJECT_NAME} (${var.ENV}"
  VPC_ID         = var.VPC.ID
}