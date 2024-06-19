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
variable "CONNECTION_ID" {
  default = ""
}

variable "CONNECTION_TYPE" {
  default = "INTERNET"
}

variable "REQUEST_PARAMETERS" {
  type    = any
  default = null
}