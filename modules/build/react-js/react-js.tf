resource "local_file" "create-env-file" {
  content  = templatefile("${path.module}/templates/env.tpl", var.REACT_APP_ENV)
  filename = "${var.SOURCE_PATH}/.env"
}
resource "null_resource" "react-js-build" {
  depends_on = [local_file.create-env-file]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
       cd ${var.SOURCE_PATH} && npm run build
    EOF
  }
}