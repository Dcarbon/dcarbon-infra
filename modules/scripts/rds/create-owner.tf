locals {
  SCRIPT_PATH     = ""
  TIMEOUT_MESSAGE = "TIMEOUT ERROR"
}
resource "null_resource" "postgres-create-owner-user" {
  provisioner "local-exec" {
    command = "psql -h ${var.DB_HOST} -U ${var.DB_USERNAME} -d ${var.DB_NAME} -c \"create user ${var.DB_USERNAME_OWNER} with password '${var.DB_PASSWORD_OWNER}'\" "
    environment = {
      PGPASSWORD = var.DB_PASSWORD
    }
  }
  provisioner "local-exec" {
    command = "psql -h ${var.DB_HOST} -U ${var.DB_USERNAME} -d ${var.DB_NAME} -c \"GRANT USAGE, CREATE ON SCHEMA public TO ${var.DB_USERNAME_OWNER}\" "
    environment = {
      PGPASSWORD = var.DB_PASSWORD
    }
  }
}
resource "null_resource" "postgres-create-uuid-ext" {
  provisioner "local-exec" {
    command = "psql -h ${var.DB_HOST} -U ${var.DB_USERNAME} -d ${var.DB_NAME} -c \"GRANT CREATE ON DATABASE ${var.DB_NAME} to ${var.DB_USERNAME_OWNER}\" "
    environment = {
      PGPASSWORD = var.DB_PASSWORD
    }
  }
}