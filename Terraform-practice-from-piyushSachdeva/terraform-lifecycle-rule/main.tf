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
  # ami           = "ami-0567589d25e06853e"
  ami          = "ami-0636d90d6337ae368"

  instance_type = "t3.small"
  tags = {
    Name        = "terraform-lifecycle-rule-instance"
  }
  lifecycle {
   //1.  create_before_destroy = true # if this is set to true then terraform will create a new instance before destroying the old instance. This is useful when we want to update the instance type or any other attribute of the instance. This will ensure that there is no downtime during the update process.

   //2.  prevent_destroy = true #  If this is set to true, Terraform will prevent the instance from being destroyed. This is useful when we want to ensure that the instance is not accidentally  destroyed while modifying or updating anything that requires deleting the existing instance and recreating it. This will also prevent the instance from being destroyed when we run the terraform destroy command, as long as this lifecycle rule remains in the configuration . 

   //3.  ignore_changes=[ami] # If we specify attributes inside ignore_changes, Terraform will ignore changes to those attributes during update planning, even if their values  differ between the terraform configuration and the real infrastructure.  This is useful when certain attributes are managed manually or by another system.

   
  }

}
