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

variable "FORCE_DESTROY" {
  default = false
}

variable "VARIABLE" {
  type = any
}

variable "TMP_FILE_NAME" {
  type = string
}