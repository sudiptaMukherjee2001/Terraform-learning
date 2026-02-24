
#Declare the variable for the AMI ID
variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
}
#Declare the variable for the instance type
variable "instance_type" {
  description = "The type of instance to use"  
    type        = string
}


variable "instance_name" {
  description = "The name of the instance"  
    type        = string
}




resource "aws_instance" "workspace" {
   ami           = var.ami_id
   instance_type = var.instance_type
   tags = {
     Name = "workspace-${var.instance_name}"
   }
}