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

variable "DISCOVERY_SERVICE_NAME" {
  type = string
}

variable "NAMESPACE_ID" {
  type = string
}

variable "DNS_RECORDS" {
  type = any
}