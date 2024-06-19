variable "INTEGRATION_TYPE" {
  type = string
}

variable "INTEGRATION_URI" {
  type = string
}

variable "API_ID" {
  type = string
}

variable "ROUTE_KEY" {
  default = "$default"
}

variable "REQUEST_PARAMETERS" {
  type    = any
  default = null
}