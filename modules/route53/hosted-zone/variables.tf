variable "TAGS" {
  type = map(string)
}

variable "HOSTED_ZONE_ID" {
  type = string
}

variable "RECORD_NAME" {
  type = string
}

variable "RECORD_TYPE" {
  type = string
  default = "A"
}

variable "TTL" {
  type = number
  default = 300
}

variable "RECORDS" {
  type = list(string)
}