variable "PROJECT_SERVICE_TYPE" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

variable "HOSTED_ZONE_ID" {
  type = string
}

variable "RECORD_NAME" {
  type = string
}

variable "ALIAS_NAME" {
  type = string
}

variable "ALIAS_ZONE_ID" {
  type = string
}

variable "TARGET_HEALTH" {
  type    = bool
  default = true
}