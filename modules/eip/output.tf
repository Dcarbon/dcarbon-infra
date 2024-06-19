output "eip-public-ip" {
  value = aws_eip.eip.public_ip
}
output "eip-public-dns" {
  value = aws_eip.eip.public_dns
}
output "eip-id" {
  value = aws_eip.eip.id
}