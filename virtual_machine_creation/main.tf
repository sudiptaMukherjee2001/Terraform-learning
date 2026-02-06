terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-2026-6102001"
    key    = "sudipta/terraform"
    region = "us-east-2"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}


provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-state-bucket-2026-6102001"
  force_destroy = true

  tags = {
    Name = "state_file_store_bucket"
  }
}

resource "aws_vpc" "terraform_created_vpc" {
  cidr_block       = "10.0.0.0/16"
  

  tags = {
    Name = "trreaform-created-vpc"
  }
}

resource "aws_subnet" "terraform_created_vpc_subnet" {
  vpc_id     = aws_vpc.terraform_created_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform_created_vpc_subnet"
  }
}



resource "aws_instance" "terraform_created_instance" {
  ami           = "ami-03ea746da1a2e36e7"
  instance_type = var.instance_type

  subnet_id = aws_subnet.terraform_created_vpc_subnet.id

  tags = {
    Name = "learn-terraform"
  }
}

