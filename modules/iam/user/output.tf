output "user-arn" {
  value = aws_iam_user.user.arn
}

output "encrypted-password" {
  value = aws_iam_user_login_profile.login-profile.encrypted_password
}

output "encrypted-secret" {
  value = aws_iam_access_key.access-key.encrypted_secret
}

output "secret-key" {
  value = aws_iam_access_key.access-key.secret
}
output "access-key" {
  value = aws_iam_access_key.access-key.id
}