resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.sg_id
  subnet_id = var.subnet_id
  tags = {
    Name = var.instance_name
    Environment = var.environment
  }
}