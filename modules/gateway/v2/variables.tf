variable "ENV" {
  type = string
}

variable "PROJECT_NAME" {
  type = string
}

variable "PROJECT_SERVICE" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

variable "ENDPOINT_TYPE" {
  default = "REGIONAL"
}

variable "SECURITY_POLICY" {
  default = "TLS_1_2"
}

variable "DOMAIN_NAME" {
  type = string
}

variable "CERTIFICATE_ARN" {
  default = ""
}

variable "IS_CUSTOM_DOMAIN" {
  default = false
}

variable "PROTOCOL_TYPE" {
  default = "HTTP"
}