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

variable "NAME" {
  type = string
}

variable "PATH" {
  default = "/"
}

variable "FORCE_DESTROY" {
  default = false
}

variable "POLICY" {
  type = any
}

variable "POLICY_NAME" {
  type = string
}