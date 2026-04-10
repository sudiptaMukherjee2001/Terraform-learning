variable "vpc_id" {
    description = "This variable is responsible for handling the vpc id"
    type = string
  
}
variable "security_group_name" {
    description = "This variable is responsible for handling the security group name"
    type = string
}
variable "from_Port" {
    description = "This variable is responsible for handling the from port"
    type = number
}
variable "to_Port" {
    description = "This variable is responsible for handling the to port"
    type = number
}

variable "vpc_cidr_ipv4" {
    description = "This variable is responsible for handling the vpc cidr block for ipv4"
    type = string
  
}