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

variable "KEY_NAME" {
  type = string
}

variable "KEY_PATH" {
  type = string
}

variable "AMI" {
  type = string
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "SUBNET_ID" {
  type = string
}

variable "SECURITY_GROUPS" {
  type = list(string)
}

variable "VOLUME_SIZE" {
  default = 30
}

variable "VOLUME_TYPE" {
  default = "gp2"
}

variable "DELETE_ON_TERMINATION" {
  default = true
}

variable "SCRIPT_FILE_NAME" {
  type = string
}

variable "SOURCE_FILE_NAME" {
  type = string
}