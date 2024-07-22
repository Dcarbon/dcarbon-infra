variable "ENV" {
  type = string
}
variable "PROJECT_SERVICE_TYPE" {
  type = string
}
variable "AWS_REGION" {
  type = string
}
variable "TAGS" {
  type = map(string)
}
variable "BUILD_RESOURCE" {
  type = list(string)
  default = []
}
variable "PROJECT_NAME" {
  type = string
}
variable "AWS_ACCOUNT_ID" {
  type = string
}