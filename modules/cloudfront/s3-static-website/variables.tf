variable "PROJECT_SERVICE_TYPE" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

variable "S3_BUCKET_NAME" {
  type = string
}
variable "S3_STATIC_WEB_DOMAIN" {
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