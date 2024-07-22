variable "TAGS" {
  type = map(string)
}

variable "PROJECT_SERVICE_TYPE" {
  type = string
}

variable "IDENTIFIER" {
  type = string
}

variable "ENGINE_VERSION" {
  default = "16.3"
}

variable "INSTANCE_CLASS" {
  default = "db.t3.micro"
}

variable "MULTI_AZ" {
  default = false
}

variable "DB_NAME" {
  type = string
}

variable "USERNAME" {
  type      = string
  sensitive = true
}

variable "PASSWORD" {
  type      = string
  sensitive = true
}

variable "STORAGE_TYPE" {
  default = "gp2"
}

variable "ALLOCATED_STORAGE" {
  default = 20
}

variable "MAX_ALLOCATED_STORAGE" {
  default = 30
}

variable "NETWORK_TYPE" {
  default = "IPV4"
}

variable "VPC_SECURITY_GROUP_IDS" {
  type = list(string)
}

variable "PERFORMANCE_INSIGHTS_ENABLED" {
  default = false
}

variable "PARAMETER_GROUP_NAME" {
  default = "default.postgres16"
}

variable "OPTION_GROUP_NAME" {
  default = "default:postgres-16"
}

variable "BACKUP_RETENTION_PERIOD" {
  type = number
}

variable "PUBLICLY_ACCESSIBLE" {
  type = bool
}

variable "DELETION_PROTECTION" {
  type = bool
}

variable "SKIP_FINAL_SNAPSHOT" {
  type = bool
}

variable "SUBNET_NAME" {
  type = string
}

variable "SUBNET_IDS" {
  type = list(string)
}

variable "PARAMETER_GROUP_NAME_CUSTOMIZE" {
  type = string
}

variable "PARAMETER_GROUP_FAMILY" {
  type = string
}

variable "PARAMETER_GROUP_PARAMETERS" {
  type = any
}