output "instance_name" {
  value= aws_instance.this.tags.Name
}
output "instance_type" {
  value= aws_instance.this.instance_type
}
output "ec2_public_ip" {
  value= aws_instance.this.public_ip
}
