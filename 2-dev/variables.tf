//COMMON
variable "AWS_REGION" {
  type = string
}
variable "AWS_ACCESS_KEY" {
  sensitive = true
}
variable "AWS_ACCESS_KEY_ROUTE53" {
  type = string
}
variable "AWS_SECRET_KEY_ROUTE53" {
  sensitive = true
}
variable "AWS_SECRET_KEY" {
  sensitive = true
}
variable "ROUTE53_HOSTED_ZONE" {
  type = object({
    ID : string
  })
}
variable "ENV" {
  type = string
}
variable "PROJECT_NAME" {
  type = string
}
# variable "PROJECT_NAME_REPOSITORY" {
#   type = string
# }
variable "CERT_DOMAIN" {
  type = string
}
variable PROJECT_SERVICES {
  type = map(string)
  default = {
    COMMON : "common"
    BACKEND : "backend"
    FRONTEND : "frontend"
    FRONTEND_APP : "frontend-app"
    SNAPSHOT : "lambda-snapshot"
    SNAPSHOT_SORT : "snapshot"
    ADMIN : "admin"
    BACKEND_ADMIN : "admin-backend"
    RPC : "rpc"
  }
}
variable "VPC" {
  type = object({
    ID : string
    CIDR_BLOCK : string
    PUBLIC_SUBNETS : list(string)
    PRIVATE_SUBNETS : list(string)
  })
}
variable "BACKEND_ENV" {
  type = list(any)
}
# variable "FRONTEND_ENV" {
#   type = list(any)
# }
variable "WAF_ID" {
  type = string
}
variable "AWS_USER_DEPLOYMENT" {
  type = string
}

# variable "ADMIN_BACKEND_ENV" {
#   type = list(any)
# }

# variable "COMMON_INFO" {
#   type = object({
#     HELIUS_RPC_URL : string
#   })
# }

variable "RPC_DOMAIN" {
  type = string
}