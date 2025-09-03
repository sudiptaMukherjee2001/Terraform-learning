variable "ami" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "ec2_name" {
  description = "Name tag for EC2"
  type        = string
}
