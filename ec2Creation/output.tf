output "instance_name" {
     value = aws_instance.example.tags.Name  
}
output "instance_type" {
     value = aws_instance.example.instance_type  
}
output "public-ip-address" {
     value = aws_instance.example.public_ip
}