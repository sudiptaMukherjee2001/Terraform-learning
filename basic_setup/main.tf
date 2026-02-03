provider "aws" {
  region = "us-east-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Create subnet in default VPC
resource "aws_subnet" "default_vpc_public" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.64.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-subnet-default-vpc-public"
  }
}


resource "aws_instance" "ec2_by_tf" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
   subnet_id = aws_subnet.default_vpc_public.id

  associate_public_ip_address = true

  tags = {
    Name = "learn-terraform"
  }
}
