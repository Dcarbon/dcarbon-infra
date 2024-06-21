variable "PUBLIC_GET_RESOURCE" {
  type = string
}

variable "CLOUDFRONT_ARN" {
  type = string
}

variable "BUCKET_ID" {
  type = string
}

variable "ACCESS_RESOURCES" {
  type = list(string)
}

variable "ACCESS_RESOURCES_IDENTIFIERS" {
  type = list(string)
}