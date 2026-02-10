root_ami_id= "ami-03ea746da1a2e36e7"
root_instance_type = "t3.micro"
root_instance_name = {
                      "stage" = "stage-web-server",
                      "prod" = "prod-web-server"
                      }
root_start_port = 22
root_end_port = 22


root_cidr_block = {
                      
                      "prod" = "10.0.1.0/24",
                      "stage" = "10.0.2.0/24"
                      }