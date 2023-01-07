output "vpc_id" {
  value = aws_vpc.module_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.module_vpc.cidr_block
}