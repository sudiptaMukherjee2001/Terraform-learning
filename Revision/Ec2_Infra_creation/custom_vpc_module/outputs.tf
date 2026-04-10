output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC created by this module"
}
output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
  description = "The CIDR block of the VPC created by this module"
}
