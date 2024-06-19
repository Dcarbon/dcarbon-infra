variable "ENV" {
  type = string
}

variable "PROJECT_NAME" {
  type = string
}

variable "PROJECT_SERVICE_TYPE" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

variable "NAME" {
  type = string
}

variable "SECURITY_GROUP_IDS" {
  type = list(string)
}

variable "SUBNET_IDS" {
  type = list(string)
}