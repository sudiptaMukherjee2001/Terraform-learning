provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "server" {
  for_each = toset(var.envs)

  ami           = "ami-03ea746da1a2e36e7" # Amazon Linux 2
  instance_type = "t3.micro"

  tags = {
    Name        = each.key
    Environment = each.key
  }
}
