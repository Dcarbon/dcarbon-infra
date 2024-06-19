variable "AWS_REGION" {
  type = string
}

variable "TAGS" {
  type = any
}

variable "CIDR_BLOCK" {
  type = string
}
variable "CIDR_BLOCK_PUBLIC_SUBNET_1" {
  type = string
}
variable "CIDR_BLOCK_PUBLIC_SUBNET_2" {
  type = string
}
variable "CIDR_BLOCK_PRIVATE_SUBNET_1" {
  type = string
}
variable "CIDR_BLOCK_PRIVATE_SUBNET_2" {
  type = string
}
variable "ALLOCATION_ID" {
  default = ""
}