resource "aws_security_group" "sg_custom" {
  name        = var.security_group_name
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Terraform Custom Security Group"
  }
 depends_on = [var.vpc_id] 
}


resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.sg_custom.id
  cidr_ipv4         = var.vpc_cidr_ipv4
  from_port         = var.from_Port
  ip_protocol       = "tcp"
  to_port           = var.to_Port
}


