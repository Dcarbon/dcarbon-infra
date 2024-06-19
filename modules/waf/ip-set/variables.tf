variable "NAME" {
  type = string
}

variable "DESCRIPTION" {
  type = string
}

variable "SCOPE" {
  default = "REGIONAL"
}

variable "IP_ADDRESS_VERSION" {
  default = "IPV4 "
}

variable "ADDRESSES" {
  type = list(string)
}

variable "TAGS" {
  type = any
}