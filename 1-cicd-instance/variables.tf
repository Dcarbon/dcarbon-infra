//COMMON
variable "AWS_REGION" {
  type = string
}
variable "AWS_ACCESS_KEY" {
  sensitive = true
}
variable "AWS_SECRET_KEY" {
  sensitive = true
}
variable "AWS_ACCESS_KEY_ROUTE53" {
  type = string
}
variable "AWS_SECRET_KEY_ROUTE53" {
  sensitive = true
}
variable "ENV" {
  default = "dev"
}
variable "PROJECT_NAME" {
  type = string
}
variable PROJECT_SERVICES {
  type = map(string)
  default = {
    COMMON : "common"
    CICD : "cicd"
    BACKEND : "backend"
    FRONTEND : "frontend"
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
variable "ROUTE53_HOSTED_ZONE" {
  type = object({
    ID : string
  })
}
variable "CERT_DOMAIN" {
  type = string
}
variable "INSTANCE_ID" {
  type = string
}