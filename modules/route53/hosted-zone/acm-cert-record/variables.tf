variable "TAGS" {
  type = map(string)
}

variable "HOSTED_ZONE_ID" {
  type = string
}

variable "DOMAIN_VALIDATION_OPTIONS" {
  type = list(map(string))
}