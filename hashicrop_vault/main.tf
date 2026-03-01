provider "aws" {
  region = "us-east-2"
}

# Add the hashicrop vault provider
provider "vault" {
  address = "http://3.145.83.157:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "b81bc807-3396-39a3-b654-e70146a14fda"
      secret_id = "73e8a833-9e22-3107-f708-566170f65221"
    }
  }
}

# retrieve the secret from vault

data "vault_kv_secret_v2" "example" {
  mount = "secret_store_path"
  name  = "test_secret"
}

# creating the aws ec2

resource "aws_instance" "example" {
  ami           = "ami-09256c524fab91d36"
  instance_type = "t3.micro"

  tags = {
    Name = data.vault_kv_secret_v2.example.data["username"]
  }
}