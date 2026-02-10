variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string

}
variable "environment" {
  description = "Environment tag for the EC2 instance"
  type        = string
}
variable "sg_id" {
  description = "Security group ID for the EC2 instance"
  type        = set(string)
}
variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}