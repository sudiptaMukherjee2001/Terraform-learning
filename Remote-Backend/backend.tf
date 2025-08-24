terraform {
  backend "s3" {
    bucket       = "sudipta-tf-remote-backend"
    key          = "sudipta-tf-remote-backend-object/terraform.tfstate"
    use_lockfile = true
    region       = "us-east-1"
  }
}
