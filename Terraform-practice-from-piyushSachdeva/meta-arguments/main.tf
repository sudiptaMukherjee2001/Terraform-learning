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


 #Ec2 instace creation using map type variable and use for_each meta-argument to create multiple ec2 instance based on the environment variable value

resource "aws_instance" "example" {
  ami           = "ami-0567589d25e06853e"
  for_each = var.instance_type_variable # this instance_type_variable  is a map type variable which is defined in variable.tf file .. This how we will access the map type variable in main.tf file and use for_each meta-argument to create multiple ec2 instance based on the environment variable value

  instance_type = each.value # here we are using each.value to get the value of the map type variable
  tags = {
    Name        = "terraform-revision-instance-${each.key}"
    Environment = each.key
  }
}



output "instance_ids" {
  value = {
    for key , instance_obj in aws_instance.example : 
    key => instance_obj.id
    
  }
}
