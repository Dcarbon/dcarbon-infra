resource "local_file" "create-file" {
  content  = templatefile("${path.module}/templates/${var.TEMPLATE_FILE_NAME}", var.APP_ENV)
  filename = var.FILE_PATH
}
