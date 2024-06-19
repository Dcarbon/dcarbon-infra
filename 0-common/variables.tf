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
variable "IP_WHITE_LIST" {
  type = list(string)
}
variable "ENV" {
  type = string
}
variable "PROJECT_NAME" {
  type = string
}
variable PROJECT_SERVICES {
  type = map(string)
  default = {
    COMMON : "common"
  }
}
variable "ROUTE53_HOSTED_ZONE" {
  type = object({
    ID : string
  })
}
variable "CERT_DOMAIN" {
  type = string
}

variable "VPC_CIDR" {
  type = object({
    CIDR_BLOCK : string
    CIDR_BLOCK_PUBLIC_SUBNET_1 : string
    CIDR_BLOCK_PUBLIC_SUBNET_2 : string
    CIDR_BLOCK_PRIVATE_SUBNET_1 : string
    CIDR_BLOCK_PRIVATE_SUBNET_2 : string
  })
}