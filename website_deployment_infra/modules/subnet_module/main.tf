resource "aws_subnet" "website_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block
  availability_zone = "us-east-2a" 
  tags = {
    Name = var.subnet_name
  }
}