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

variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "instance_name" {
  type = string
}



module "ec2_creation" {
    source = "./ec2_module"
    ami_id = var.ami_id
    instance_type = var.instance_type
    instance_name = var.instance_name
  
}
