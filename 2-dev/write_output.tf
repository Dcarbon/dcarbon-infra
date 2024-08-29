resource "local_file" "write-output" {
  filename = "output_private.json"
  content = jsonencode({
    VPC = {
      USER_APPLICATION_AWS_ACCESS_KEY = module.user-application.access-key
      USER_APPLICATION_AWS_SECRET_KEY = module.user-application.secret-key
    },
    LAMBDA_MINTING_ARN = module.lambda-minting-iam.iam-role-arn
  })
}