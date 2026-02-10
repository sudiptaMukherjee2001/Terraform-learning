output "website_subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.website_subnet.id
}