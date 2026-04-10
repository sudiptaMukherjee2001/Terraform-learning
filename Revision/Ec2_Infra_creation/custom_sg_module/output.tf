output "sg_name" {
    value = aws_security_group.sg_custom.name
    description = "This output is responsible for handling the security group name"
  
}
output "sg_id" {
    value = aws_security_group.sg_custom.id
    description = "This output is responsible for handling the security group id"
  
}