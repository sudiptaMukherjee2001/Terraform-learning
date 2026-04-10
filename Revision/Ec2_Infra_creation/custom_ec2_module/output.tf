output "ec2_name" {
    value = aws_instance.example.tags.Name
    description = "This output is responsible for handling the ec2 instance name"
  
}
output "ec2_public_ip" {
    value = aws_instance.example.public_ip
    description = "This output is responsible for handling the public ip of the ec2 instance"
  
}