resource "aws_instance" "terraform_created_instance" {
  ami           = "ami-03ea746da1a2e36e7"
  instance_type = var.instance_type_name

  tags = {
    Name = var.instance_name
  }
}
