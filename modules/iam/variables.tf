variable "PROJECT_SERVICE_TYPE" {
  type = string
}
variable "TAGS" {
  type = map(string)
}

variable "ROLE_NAME" {
  type = string
}

variable "ROLE_DESCRIPTION" {
  type = string
}

variable "ASSUME_ROLE_POLICY" {
  type = any
}

variable "INLINE_POLICY" {
  type = list(any)
  default = []
}

variable "ATTACK_POLICY_ARN" {
  type = string
  default = null
}
