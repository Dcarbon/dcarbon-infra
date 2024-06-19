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

variable "TASK_DEFINITION_ARN" {
  type = string
}

variable "LAUNCH_TYPE" {
  type    = string
  default = "FARGATE"
}

variable "SCHEDULING_STRATEGY" {
  type    = string
  default = "REPLICA"
}

variable "DESIRED_COUNT" {
  type    = number
  default = 1
}

variable "VPC_SUBNETS" {
  type = list(string)
}

variable "ECS_SECURITY_GROUPS" {
  type = list(string)
}

variable "D_MIN_HEALTHY_PERCENT" {
  type = number
}

variable "D_MAX_PERCENT" {
  type = number
}

variable "REGISTRY_ARN" {
  type = string
}
variable "REGISTRY_PORT" {
  default = 80
}

variable "WAIT_FOR_STEADY_STATE" {
  default = false
}