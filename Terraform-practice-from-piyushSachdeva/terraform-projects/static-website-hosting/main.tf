terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#fetching the  existing vpc id -0 not required for for this s3 and cloudfront example but just to show how to fetch existing vpc id using data source

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["data-source-vpc"]
  }
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}


# Create an S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3-cf-hosting-2026-10-27"
}

#Ownership controls to set the bucket owner 
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced" #Bucket owner always owns the objects; ACLs are disabled. 
  }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

 block_public_acls       = true
  block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true
}

#bucket policy to allow cloudfront to access the s3 bucket
resource "aws_s3_bucket_policy" "cloudfront_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid       = "AllowCloudFrontRead"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3_bucket.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })
}



output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}