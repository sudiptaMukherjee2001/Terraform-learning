variable "instance_type_variable" {
  type = map(string)
  default = {
    dev     = "t3.micro"
    preprod = "t3.small"
   
  }
}
