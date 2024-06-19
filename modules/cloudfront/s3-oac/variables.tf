variable "PROJECT_SERVICE_TYPE" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

variable "ENV" {
  type = string
}

variable "PROJECT_NAME" {
  type = string
}

variable "S3_BUCKET_DOMAIN_NAME" {
  type = string
}

variable "CERT_ARN" {
  type = string
}

variable "DOMAIN_NAME" {
  type = string
}