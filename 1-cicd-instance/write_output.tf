resource "local_file" "write-output" {
  filename = "output_private.json"
  content = jsonencode({
    AWS_ACCESS_KEY : module.user-cicd.access-key
    AWS_SECRET_KEY : module.user-cicd.secret-key
    AWS_REGION : var.AWS_REGION
    AWS_FAMILY : "${module.current-account.current_account_id}.dkr.ecr.${var.AWS_REGION}.amazonaws.com"
    PROJECT_NAME : var.PROJECT_NAME
  })
}