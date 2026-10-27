#creatin variable

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "tf-example"
}

variable "environment" {
  description = "The environment for the VPC"
  type        = string
  default     = "dev"
}


variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "instance_tags"{
    description = "Tags for the EC2 instance"
    type = list(string)
    default = ["terraform-revision-ec2-iam-user","preprod-EC2-environment"]
}






#creting map type variblle which is having object type in it which is having 4 attributes
variable "inbound_cidr_block" {
  description = "Inbound CIDR blocks for the security group"

  type = map(object({
    cidr_ipv4   = string
    from_port   = number
    ip_protocol = string
    to_port     = number
  }))

  default = {
    http = {
      cidr_ipv4   = "10.0.0.0/8"
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
    }

    https = {
      cidr_ipv4   = "192.168.0.0/16"
      from_port   = 443
      ip_protocol = "tcp"
      to_port     = 443
    }
    ssh = {
      cidr_ipv4   = "192.168.0.0/16"
      from_port   = 22
      ip_protocol = "tcp"
      to_port     = 22
    }
  }
}

# creating map type variable for instance type
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = map(string)
  default     = {
    dev = "t3.micro"
    preprod = "t3.small"
    prod = "t3.medium"  
  }
}

variable "Ec2_environment" {
  description = "The environment for the ec2 instance"
  type        = string
  default     = "dev"
}


