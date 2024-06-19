variable "PROJECT_SERVICE_TYPE" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

variable "GATEWAY_ID" {
  type = string
}
variable "GATEWAY_DOMAIN" {
  type = string
}

variable "DOMAIN_NAME" {
  type = string
}

variable "CERT_ARN" {
  type = string
}

variable "WAF_ID" {
  default = ""
}
variable "CUSTOM_HEADERS" {
  type = any
  default = []
}

variable "FORWARDED_HEADERS" {
  type = list(string)
  default = null
}

variable "ORIGIN_PATH" {
  default = ""
}