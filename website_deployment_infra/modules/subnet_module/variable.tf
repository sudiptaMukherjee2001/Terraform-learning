variable "vpc_id" {
    description = "VPC ID where the subnet will be created"
    type        = string
  
}
variable "cidr_block" {
    description = "The CIDR block for the subnet"
    type        = string
  
}
variable "subnet_name" {
    description = "The name of the subnet"
    type        = string
  
}