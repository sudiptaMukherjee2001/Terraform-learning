#1. first will create vpc
#2. then will create subnet
#3. then using data source will get the vpc id and subnet id


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


variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

resource "aws_vpc" "data_source_vpc_internal_name" {
  cidr_block       = var.vpc_cidr
 

  tags = {
    Name = "data-source-vpc"
  }
}



# data "aws_vpc" "selected_vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["data-source-vpc"]
#   }
# }

resource "aws_subnet" "data_source_subnet_internal_name" {
  vpc_id     = aws_vpc.data_source_vpc_internal_name.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "data-source-subnet"
  }
  depends_on = [aws_vpc.data_source_vpc_internal_name]
}


# data "aws_subnet" "selected_subnet" {
#   filter {
#     name   = "tag:Name"
#     values = ["data-source-subnet"]
#   }
# }




# resource "aws_instance" "example" {
#   ami           = "ami-0567589d25e06853e"
#   instance_type = "t3.micro"
#   subnet_id     = data.aws_subnet.selected_subnet.id # this will get the subnet id from data source and will use it to create ec2 instance
  
#   tags = {
#     Name = "data-source-ec2"
#   }
# }

output "vpc_id" {
  value = aws_vpc.data_source_vpc_internal_name.id
}
output "subnet_id" {
  value = aws_subnet.data_source_subnet_internal_name.id
}

