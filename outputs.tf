output "vpc_id" {
  value = aws_vpc.roboshop_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database_subnet[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.gateway.id
}