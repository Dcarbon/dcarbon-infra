output "media-live-access-role-arn" {
  value = one(aws_iam_role.media-live-access.*.arn)
}
output "ecs-task-execute-role-arn" {
  value = one(aws_iam_role.ecs-task-execute.*.arn)
}
output "appsync-logs-execute-role-arn" {
  value = one(aws_iam_role.appsync-logs-execute.*.arn)
}