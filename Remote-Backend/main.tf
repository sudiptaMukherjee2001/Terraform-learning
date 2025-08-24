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

resource "aws_instance" "remoteBackend" {
    ami = "ami-0de716d6197524dd9"
    instance_type = "t2.micro"
    tags = {
      Name : "t2.microo-test"
    }
  
}


resource "aws_s3_bucket" "example" {
  bucket = "sudipta-tf-remote-backend"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}