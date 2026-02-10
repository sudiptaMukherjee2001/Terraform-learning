resource "aws_vpc" "website_vpc" {
  cidr_block       = "10.0.0.0/16"
  

  tags = {
    Name = "website_vpc"
  }
}


