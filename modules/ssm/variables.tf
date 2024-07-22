variable "ENV_LIST" {
  type = map(object({
    name        = string
    description = string
    type        = string
    value       = any
  }))
}

variable "TAGS" {
  type = any
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