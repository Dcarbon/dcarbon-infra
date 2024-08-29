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
    MINTING : "lambda-minting"
    ADMIN : "admin"
    ADMIN_PO : "po"
    BACKEND_ADMIN : "admin-backend"
    BACKEND_PO : "po-backend"
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
variable "IP_WHITE_LIST" {
  type = list(string)
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
variable "DMARC_RECORD" {
  type = string
}
variable "ADMIN_BACKEND_ENV_SSM" {
  type = any
}
variable "PO_BACKEND_ENV_SSM" {
  type = any
}
variable "BACKEND_ENV_SSM" {
  type = any
}
variable "DATABASE_ADMIN_AUTH" {
  type = object({
    username : string
    password : string
  })
  sensitive = true
}
variable "DATABASE_OWNER_AUTH" {
  type = object({
    username : string
    password : string
  })
  sensitive = true
}

variable "ARWEAVE_SECRET" {
  type = any
}