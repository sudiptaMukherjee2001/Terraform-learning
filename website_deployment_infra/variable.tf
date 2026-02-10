variable "root_ami_id" {
  description = "The AMI ID for the root instance"
  type        = string
}

variable "root_instance_type" {
  description = "The instance type for the root instance"
  type        = string
}

variable "root_instance_name" {
  description = "The name tag for the root instance"
  type        = map(string)
}
variable "root_cidr_block" {
  description = "The CIDR block for the root subnet"
  type        = map(string)
}
variable "root_start_port" {
  description = "The start port for the root instance"
  type        = number
}
variable "root_end_port" {
  description = "The end port for the root instance"
  type        = number
}