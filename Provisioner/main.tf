terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "us-east-2"
}

# Create a key pair for SSH access to the EC2 instance
#It will upload the public key from the specified file path to AWS, allowing you to use the corresponding private key for SSH access to the EC2 instance created later in the configuration.
resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Fetch the default VPC to associate the security group with it
data "aws_vpc" "default" {
  default = true
}

# Create a security group to allow inbound traffic on port 22 for ssh login
resource "aws_security_group" "provisoner_sg" {
  name        = "allow_provisioner_sg"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "allow_provisioner_sg"
  }
}
# Allow inbound traffic on port 22 for SSH access
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.provisoner_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.provisoner_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#Creating the ec2 infra
resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.mykey.key_name
  #attach the security group to the instance
  vpc_security_group_ids=[aws_security_group.provisoner_sg.id]
  tags = {
    Name = "nginx-installation"
  }
  depends_on = [ aws_key_pair.mykey, aws_security_group.provisoner_sg ]

  
    # ... resource configuration ...
    connection {
    type        = "ssh"
    user        = "ubuntu" # Specifies the user for the SSH connection
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx"
    ]
  }


}

