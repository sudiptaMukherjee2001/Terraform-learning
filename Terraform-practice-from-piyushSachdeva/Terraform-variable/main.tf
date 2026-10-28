/*
From this file we  will understand this are the topics listed below
1. How to use locals block in terraform
2. How to use map type variable in terraform
3. How to use object in map type variable in terraform - refer inbound_cidr_block variable in variable.tf file

4. How to use for_each loop in terraform to create multiple resources
5. How to use outputs in terraform



*/
locals {
  cidr    = var.vpc_cidr
  vpcName = var.vpc_name
  Env     = var.environment
}


#create a VPC
resource "aws_vpc" "example" {
  cidr_block = local.cidr
  #   cidr_block = var.vpc_cidr

  tags = {
    Name        = local.vpcName
    Environment = local.Env
  }
}
resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.subnet_cidr[1]

  tags = {
    Name = "terraform-revision-subnet"
  }
}

#creating ec2 instance
resource "aws_instance" "example" {
  ami = "ami-052b3645c2c811821"

  // if default is terraform plan -var="env=prod"var.Ec2_environment == "dev"  then  insrance_type = "t3.micro"

  // if var.Ec2_environment == "preprod"  then  insrance_type = "t3.small" we can override default value of environment by using -var="Ec2_environment=preprod" in terraform plan command -> terraform plan -var="Ec2_environment=prod"

  // if var.Ec2_environment == "prod"  then  insrance_type = "t3.medium" , we can override default value of environment by using -var="Ec2_environment=prod" in terraform plan command -> terraform plan -var="Ec2_environment=prod"

  instance_type = var.instance_type[var.Ec2_environment] #here we will use map type variable to create instance type


  subnet_id = aws_subnet.example.id
  

  vpc_security_group_ids = [aws_security_group.example.id]



  tags = {
    Name        = var.instance_tags[0]
    environment = var.Ec2_environment
  }
}

#create a security group
resource "aws_security_group" "example" {
  name        = "terraform-revision-sg"
  description = "example"
  vpc_id      = aws_vpc.example.id
  tags = {
    Name = "preprod-sg"
  }
}

#inbound rule for security group for http
/*resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.example.id

  cidr_ipv4   = var.inbound_cidr_block[0]
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}


#inbound rule for security group for https
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.example.id

  cidr_ipv4   = var.inbound_cidr_block[0]
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}*/


#one of the best way to create inbound rule for security group is to use map type variable which is having object type in it which is having 4 attributes and then we can use for_each loop to create multiple inbound rules for security group

resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.example.id
  for_each = var.inbound_cidr_block
  cidr_ipv4   = each.value.cidr_ipv4
  from_port   = each.value.from_port
  ip_protocol = each.value.ip_protocol
  to_port     = each.value.to_port
}






#how to use outputs

output "vpc_Id" {
  value = aws_vpc.example.id
}
output "subnet_Id" {
  value = aws_subnet.example.id
}
output "instance_Id" {
  value = aws_instance.example.id
}
output "security_group_Id" {
  value = aws_security_group.example.id
}

