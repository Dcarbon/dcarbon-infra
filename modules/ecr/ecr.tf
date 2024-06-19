resource "aws_ecr_repository" "main-ecr" {
  count        = var.CREATE_REPOSITORY_FLG ? 1 : 0
  name         = "${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICE_TYPE}"
  force_delete = var.FORCE_DELETE
  tags         = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}-ecr"
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}
resource "null_resource" "build-image" {
  count      = var.BUILD_IMAGE_FLG ? 1 : 0
  depends_on = [aws_ecr_repository.main-ecr]
#  triggers   = {
#    docker_file = md5(file("${var.IMAGE_FILE_PATH}/Dockerfile"))
#  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
       docker build --build-arg NEXT_PUBLIC_API_ENDPOINT=https://dev-api.kyupad.xyz --build-arg NEXT_PUBLIC_BASE_URL=https://dev.kyupad.xyz --build-arg NEXT_PUBLIC_AUTH_METHOD=cookie --build-arg NEXT_PUBLIC_NETWORK=testnet --build-arg NEXT_PUBLIC_ALLOWED_ORIGINS=aaa,b -t ${var.CREATE_REPOSITORY_FLG ? aws_ecr_repository.main-ecr[count.index].name : var.REPOSITORY_NAME} ${var.IMAGE_FILE_PATH} &&
      docker tag ${var.CREATE_REPOSITORY_FLG ? aws_ecr_repository.main-ecr[count.index].name : var.REPOSITORY_NAME}:latest ${var.CREATE_REPOSITORY_FLG ? aws_ecr_repository.main-ecr[count.index].repository_url: var.REPOSITORY_URL}:latest
    EOF
  }
}

resource "null_resource" "ecr-push" {
  count      = var.BUILD_IMAGE_FLG ? 1 : 0
  depends_on = [null_resource.build-image]
#  triggers   = {
#    docker_file = md5(file("${var.IMAGE_FILE_PATH}/Dockerfile"))
#  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
       AWS_ACCESS_KEY_ID=${var.AWS_ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${var.AWS_SECRET_KEY} aws ecr get-login-password --region ${var.AWS_REGION} | docker login --username AWS --password-stdin ${var.AWS_ACCOUNT_ID}.dkr.ecr.${var.AWS_REGION}.amazonaws.com &&
       docker push ${var.CREATE_REPOSITORY_FLG ? aws_ecr_repository.main-ecr[count.index].repository_url: var.REPOSITORY_URL}:latest
    EOF
  }
}