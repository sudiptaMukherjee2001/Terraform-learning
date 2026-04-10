resource "aws_subnet" "custom_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr

  tags = {
    Name = var.subnet_name
  }
  depends_on = [ var.vpc_id ]
}