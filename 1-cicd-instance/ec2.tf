locals {
  AMIS = {
    ap-southeast-1 = "ami-04c913012f8977029"
    us-west-2      = "ami-06b94666"
    eu-west-1      = "ami-844e0bf7"
    ap-northeast-1 = "ami-0f9fe1d9214628296"
  }
}

module "cicd-ec2-security-group" {
  source = "../modules/security-groups"
  #  depends_on                 = [module.vpc]
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.CICD
  SECURITY_GROUP_NAME  = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICES.CICD}-sg"
  SECURITY_GROUP_DESCRIPTION = "(${var.ENV}) This Security Group use for load balancer of ${var.PROJECT_NAME} ${var.PROJECT_SERVICES.CICD}"
  #  VPC_ID                     = module.vpc.vpc_id
  VPC_ID               = var.VPC.ID
  SECURITY_GROUP_INBOUNDS = {
    "80" : {
      "from_port" : 80,
      "to_port" : 80,
      "description" : "Jenkins",
      "cidr_blocks" : ["0.0.0.0/0"]
      "security_groups" : [],
      "protocol" : "tcp"
    },
    "22" : {
      "from_port" : 22,
      "to_port" : 22,
      "description" : "SSH",
      "cidr_blocks" : var.IP_WHITE_LIST
      "security_groups" : [],
      "protocol" : "tcp"
    }
  }
  TAGS = local.common-tags
}
module "cicd-ec2-eip" {
  source               = "../modules/eip"
  PROJECT_NAME         = var.PROJECT_NAME
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.CICD
  ENV                  = var.ENV
  TAGS                 = local.common-tags
  INSTANCE             = var.INSTANCE_ID
}
module "cicd-ec2-route53-record" {
  depends_on = [module.cicd-ec2-eip]
  source         = "../modules/route53/hosted-zone"
  TAGS           = local.common-tags
  HOSTED_ZONE_ID = var.ROUTE53_HOSTED_ZONE.ID
  RECORD_NAME    = "${var.PROJECT_NAME}-cicd.${var.CERT_DOMAIN}"
  RECORDS = [module.cicd-ec2-eip.eip-public-ip]
  providers = {
    aws = aws.route53-provider
  }
}
# module "create-deploy-backend-env-file" {
#   source             = "../modules/common/create_file"
#   FILE_PATH          = "${path.cwd}/../modules/ec2/env/${var.ENV}/${var.PROJECT_SERVICES.COMMON}/.env.deploy"
#   TEMPLATE_FILE_NAME = "${var.PROJECT_SERVICES.BACKEND}/env.deploy.tpl"
#   APP_ENV = {
#     AWS_ACCESS_KEY : module.user-cicd.access-key
#     AWS_SECRET_KEY : module.user-cicd.secret-key
#     AWS_REGION : var.AWS_REGION
#     AWS_FAMILY : "${module.current-account.current_account_id}.dkr.ecr.${var.AWS_REGION}.amazonaws.com"
#     PROJECT_NAME : var.PROJECT_NAME
#   }
# }
