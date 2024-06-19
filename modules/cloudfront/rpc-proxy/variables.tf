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

variable "LAMBDA_EDGE_RPC_ADD_APIKEY_ARN" {
  type = string
}