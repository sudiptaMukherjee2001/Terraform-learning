terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.31.0"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

module "vpc_creation" { 
  source = "./modules/vpc_module" 
  vpc_id = module.vpc_creation.vpc_id
}

module "subnet_creation" {
  source = "./modules/subnet_module"
  # It will create two subnets, one for stage and another for prod environment, based on the CIDR blocks provided in the variable file. The subnet names will also be derived from the keys of the root_cidr_block variable.
  for_each = var.root_cidr_block
  cidr_block = each.value
  subnet_name= each.key
  vpc_id = module.vpc_creation.vpc_id
  depends_on = [ module.vpc_creation ]
  
}
module "sg_creation" {
  source = "./modules/sg_module"
  start_port = var.root_start_port
  end_port = var.root_end_port
  vpc_id = module.vpc_creation.vpc_id
  cidr_block = module.vpc_creation.vpc_cidr_block
  depends_on = [ module.vpc_creation ]
}

# this module is responsible for creating EC2 instance for web server - stage and prod environment
module "ec2_creation" {
  source = "./modules/ec2_module"
  for_each = var.root_instance_name
  ami_id = var.root_ami_id
  instance_type = var.root_instance_type
  sg_id = [module.sg_creation.security_group_id]
  instance_name = each.value
  environment = each.key
  subnet_id = module.subnet_creation[each.key].website_subnet_id # This will fetch the subnet ID for the corresponding environment (stage or prod) from the subnet_creation module using the key of the root_instance_name variable.
  depends_on = [ module.sg_creation ]
  
}






output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_creation.vpc_id
  
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc_creation.vpc_cidr_block
}
output "website_subnet_id" {
 
  description = "The ID of the subnet"
   value = {
    for env, mod in module.subnet_creation :
    env => mod.website_subnet_id
  }
}