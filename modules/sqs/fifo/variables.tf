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

variable "VISIBILITY_TIMEOUT_SECONDS" {
  default = 30
}

variable "MESSAGE_RETENTION_SECONDS" {
  default = 345600
}

variable "DELAY_SECONDS" {
  default = 0
}

variable "MAX_MESSAGE_SIZE" {
  default = 262144
}

variable "RECEIVE_WAIT_TIME_SECONDS" {
  default = 0
}

variable "DEDUPLICATION_SCOPE" {
  default = "messageGroup"
}

variable "FIFO_THROUGHPUT_LIMIT" {
  default = "perMessageGroupId"
}

variable "SQS_MANAGED_SSE_ENABLED" {
  default = true
}

variable "VISIBILITY_TIMEOUT_SECONDS_DL" {
  default = 30
}

variable "MESSAGE_RETENTION_SECONDS_DL" {
  default = 345600
}

variable "DELAY_SECONDS_DL" {
  default = 0
}

variable "MAX_MESSAGE_SIZE_DL" {
  default = 262144
}

variable "RECEIVE_WAIT_TIME_SECONDS_DL" {
  default = 0
}

variable "DEDUPLICATION_SCOPE_DL" {
  default = "messageGroup"
}

variable "FIFO_THROUGHPUT_LIMIT_DL" {
  default = "perMessageGroupId"
}

variable "SQS_MANAGED_SSE_ENABLED_DL" {
  default = true
}

variable "MAX_RECEIVE_COUNT" {
  default = 3
}

variable "POLICY_STATEMENT" {
  type = any
}

variable "POLICY_STATEMENT_CONDITION" {
  type = any
}