variable "start_port" {
  description = "start port number"
  type = number
}
variable "end_port" {
  description = "end port number"
  type = number
}
variable "vpc_id" {
  description = "The VPC ID"
  type = string
}
variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type = string
}