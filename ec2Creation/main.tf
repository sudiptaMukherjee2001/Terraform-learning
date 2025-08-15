terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  tags ={
    Name = "Terraform-Instance"
  }
}

