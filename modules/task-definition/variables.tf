variable "AWS_REGION" {
  type = string
}

variable "AWS_ACCOUNT_ID" {
  type      = string
  sensitive = true
}
variable "ENV" {
  type = string
}

variable "PROJECT_NAME" {
  type = string
}

variable "PROJECT_SERVICE_TYPE" {
  type = string
}

variable "ECS_TASK_EXECUTE_ROLE_ARN" {
  type = string
}
variable "TASK_MEMORY_SIZE" {
  type    = string
  default = "512"
}
variable "COMPATIBILITIES" {
  type    = list(string)
  default = [
    "EC2",
    "FARGATE"
  ]
}
variable "REQUIRES_COMPATIBILITIES" {
  type = list(string)
  default = ["FARGATE"]
}
variable "RUNTIME_PLATFORM" {
  type = map(string)
  default = {
    "operating_system_family": "LINUX",
    "cpu_architecture": "X86_64"
  }
}
variable "CPU_SIZE" {
  type = string
  default = "256"
}
variable "CONTAINER_PORT_MAPPING" {
  type = number
  default = 80
}
variable "ECR_IMAGE_URL" {
  type = string
}
variable "CONTAINER_ENVIRONMENT" {
  type = list(any)
}

variable "CONTAINER_NAME" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

