output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.terraform_created_instance.public_ip
}
