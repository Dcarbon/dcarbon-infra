output "main-vpc-id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main-vpc.id
}

output "main-vpc-cidr" {
  description = "The ID of the VPC"
  value       = aws_vpc.main-vpc.cidr_block
}

output "main-public-subnets" {
  description = "List of IDs of public subnets"
  value       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
}

output "main-private-subnets" {
  description = "List of IDs of private subnets"
  value       = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]
}

output "main-public-route-table" {
  value = aws_route_table.main-public-rtb.id
}