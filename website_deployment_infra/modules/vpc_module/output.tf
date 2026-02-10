output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.website_vpc.id
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.website_vpc.cidr_block
}
