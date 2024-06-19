locals {
  common-tags = {
    Terraform = "true"
  }
}

module "vpc" {
  source                      = "../modules/vpc"
  AWS_REGION                  = var.AWS_REGION
  TAGS                        = local.common-tags
  CIDR_BLOCK                  = var.VPC_CIDR.CIDR_BLOCK
  CIDR_BLOCK_PUBLIC_SUBNET_1  = var.VPC_CIDR.CIDR_BLOCK_PUBLIC_SUBNET_1
  CIDR_BLOCK_PUBLIC_SUBNET_2  = var.VPC_CIDR.CIDR_BLOCK_PUBLIC_SUBNET_2
  CIDR_BLOCK_PRIVATE_SUBNET_1 = var.VPC_CIDR.CIDR_BLOCK_PRIVATE_SUBNET_1
  CIDR_BLOCK_PRIVATE_SUBNET_2 = var.VPC_CIDR.CIDR_BLOCK_PRIVATE_SUBNET_2
}