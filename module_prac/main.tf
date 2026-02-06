terraform {
  

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


module "ec2_creation" {
  # for_each = var.instances
  source = "./ec2_module"
  # instance_name = each.key
  instance_name = "my-terraform-module-instance"
  # instance_type_name = each.value
  instance_type_name = "t3.micro"
}

