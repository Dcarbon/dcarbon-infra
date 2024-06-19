data "aws_caller_identity" "current" {}

output "current_account_id" {
  value = data.aws_caller_identity.current.id
}
output "current_account_arn" {
  value = data.aws_caller_identity.current.arn
}