output "ecr-repository-url" {
  value = one(aws_ecr_repository.main-ecr.*.repository_url)
}