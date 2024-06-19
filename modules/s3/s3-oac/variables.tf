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

variable "BUCKET_NAME" {
  type = string
}

variable "FORCE_DESTROY" {
  default = false
}

variable "VARIABLE" {
  type = any
}

variable "TMP_FILE_NAME" {
  type = string
}

variable "USE_BUCKET_ACL" {
  default = false
}

variable "ACL_TYPE" {
  default = "private"
}

variable "BLOCK_PUBLIC_ACLS" {
  default = false
}

variable "BLOCK_PUBLIC_POLICY" {
  default = false
}

variable "IGNORE_PUBLIC_ACLS" {
  default = false
}

variable "RESTRICT_PUBLIC_BUCKETS" {
  default = false
}

variable "ALLOWED_HEADERS" {
  default = ["*"]
}

variable "ALLOWED_METHODS" {
  default = ["GET", "POST", "PUT"]
}

variable "ALLOWED_ORIGINS" {
  default = ["*"]
}

variable "USE_BUCKET_CORS" {
  default = false
}

variable "MAX_AGE_SECONDS" {
  default = 3000
}

variable "EXPOSE_HEADERS" {
  default = []
}