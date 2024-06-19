variable "TAGS" {
  type = map(string)
}
variable "DOMAIN_NAME" {
  type = string
}
variable "VALIDATION_METHOD" {
  default = "DNS"
}
variable "SUBJECT_ALTERNATIVE_NAMES" {
  type = list(string)
  default = []
}