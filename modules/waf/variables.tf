variable "NAME" {
  type = string
}

variable "DESCRIPTION" {
  type = string
}

variable "SCOPE" {
  default = "REGIONAL"
}

variable "TAGS" {
  type = any
}

variable "IP_SET_RULE_NAME" {
  type = string
}

variable "IP_SET_ARN" {
  type = string
}

variable "IP_SET_V6_ARN" {
  type = string
}