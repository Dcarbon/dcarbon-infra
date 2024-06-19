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

variable "AWS_ACCOUNT_ID" {
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

variable "CREATE_REPOSITORY_FLG" {
  type = bool
  default = true
}

variable "BUILD_IMAGE_FLG" {
  type = bool
  default = false
}

variable "IMAGE_FILE_PATH" {
  type = string
  default = ""
}

variable "REPOSITORY_NAME" {
  type = string
  default = ""
}

variable "REPOSITORY_URL" {
  type = string
  default = ""
}

variable "FORCE_DELETE" {
  type = bool
  default = false
}

variable "BUILD_ARG" {
  default = ""
}