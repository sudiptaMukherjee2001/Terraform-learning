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

module "ec2_creation" {
  source = "../module/ec2CreationModule"
  ami=var.ami_value
  instance_type=var.instance_type_value
  ec2_name=var.ec2_name_value
  
}

module "s3_creation" {
  source = "../module/s3CreationModule"
  bucket_names = var.bucket_names_value
  environment = var.environment_value

  
}