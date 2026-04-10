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
##Custom VPC module
module "custom_vpc" {
    source = "./custom_vpc_module"
    vpc_name = "my_custom_vpc"
    vpc_cidr = "10.0.0.0/16"
}

##Custom subnet module
module "custom_subnet" {
    source = "./custom_subnet_module"
    subnet_name = "my_custom_subnet"
    subnet_cidr = "10.0.1.0/24"
    vpc_id = module.custom_vpc.vpc_id # This is how we are passing the vpc id from custom_vpc_module to custom_subnet_module usning output variable
}

##Custom security group module
module "custom_sg" {
    source = "./custom_sg_module"
    vpc_id = module.custom_vpc.vpc_id # This is how we are passing the vpc id from custom_vpc_module to custom_sg_module usning output vpc_id present in output.tf in vpc module
    vpc_cidr_ipv4 = module.custom_vpc.vpc_cidr # This is how we are passing the vpc cidr block for ipv4 from custom_vpc_module to custom_sg_module usning output vpc_cidr present in output.tf in vpc module
    security_group_name = "my_custom_security_group"
    from_Port = 443
    to_Port = 443
  
}

# #Custom EC2 module
module "custom_ec2" {
    source = "./custom_ec2_module"
    ami_id = "ami-0ea87431b78a82070" # us-east-1
    instance_type = "t3.micro"
    subnet_id = module.custom_subnet.subnet_id
    security_group_name = module.custom_sg.sg_id
    instance_name = "my_custom_ec2_instance"
}





output "custom_vpc_ip" {
    value = module.custom_vpc.vpc_id
    description = "This output is responsible for handling the vpc id"
  
}

output "custom_sg_name" {
    value = module.custom_sg.sg_name
    description = "This output is responsible for handling the security group name"
  
}

output "ec2_instance_name" {
    value = module.custom_ec2.ec2_name
    description = "This output is responsible for handling the ec2 instance name"
  
}
output "public_ip" {
    value = module.custom_ec2.ec2_public_ip
    description = "This output is responsible for handling the ec2 instance public IP"
  
}