variable "AWS_ACCESS_KEY" {
  type = string
  sensitive = true
}
variable "AWS_SECRET_KEY" {
  type = string
  sensitive = true
}
variable "AWS_REGION" {
  type = string
}

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

variable "BUCKET_NAME" {
  type = string
}

variable "SOURCE_PATH" {
  type = string
}

variable "MIME_TYPES" {
  type = any
}

variable "FORCE_DESTROY" {
  default = false
}