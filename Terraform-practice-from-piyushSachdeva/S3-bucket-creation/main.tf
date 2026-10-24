terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "s3-backend-state-locking"
    key    = "statefile"
    region = "us-east-1"
    use_lockfile = true
  }
  
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-123456oct20016789" # Change this to a unique bucket name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# resource "aws_s3_bucket" "example1" {
#   bucket = "s3-backend-state-locking" # Change this to a unique bucket name

#   tags = {
#     Name        = "s3-backend-state-locking "
#     Environment = "Dev"
#   }
# }
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}
