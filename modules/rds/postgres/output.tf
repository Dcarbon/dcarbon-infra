output "postgres-db-address" {
  value     = aws_db_instance.postgres-rds.address
  sensitive = true
}

output "postgres-db-name" {
  value     = aws_db_instance.postgres-rds.db_name
  sensitive = true
}

output "postgres-db-username" {
  value     = aws_db_instance.postgres-rds.username
  sensitive = true
}

output "postgres-db-password" {
  value     = aws_db_instance.postgres-rds.password
  sensitive = true
}