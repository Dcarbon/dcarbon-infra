provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION
}

provider "aws" {
  alias = "us-east-1-provider"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = "us-east-1"
}
provider "aws" {
  alias = "route53-provider"
  access_key = var.AWS_ACCESS_KEY_ROUTE53
  secret_key = var.AWS_SECRET_KEY_ROUTE53
  region     = var.AWS_REGION
}