resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_name]
  associate_public_ip_address= true

  tags = {
    Name = var.instance_name
  }
}