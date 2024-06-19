variable "SECURITY_GROUP_NAME" {
  type = string
}
variable "SECURITY_GROUP_DESCRIPTION" {
  type = string
}

variable "VPC_ID" {
  type = string
}

variable "PROJECT_SERVICE_TYPE" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

variable "SECURITY_GROUP_INBOUNDS" {
  type = any
  default = {}
}
