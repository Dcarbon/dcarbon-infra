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

variable "NAME" {
  type = string
}

variable "FLEXIBLE_TIME_WINDOW_MODE" {
  default = "OFF"
}

variable "SCHEDULE_EXPRESSION" {
  type = string
}

variable "GROUP_NAME" {
  type = string
}

variable "TARGET_ARN" {
  type = string
}

variable "TARGET_ROLE_ARN" {
  type = string
}

variable "MAXIMUM_EVENT_AGE_IN_SECONDS" {
  default = 300
}

variable "MAXIMUM_RETRY_ATTEMPTS" {
  default = 5
}

variable "TARGET_INPUT" {
  type = any
}

variable "SQS_MESSAGE_GROUP_ID" {
  type = string
}