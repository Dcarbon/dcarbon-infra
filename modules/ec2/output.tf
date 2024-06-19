output "ec2-instance-id" {
  value = aws_instance.ec2-instance.id
}

output "ec2-public-dns" {
  value = aws_instance.ec2-instance.public_dns
}

output "ec2-pem-key" {
  value = aws_key_pair.ec2-key.key_name
}