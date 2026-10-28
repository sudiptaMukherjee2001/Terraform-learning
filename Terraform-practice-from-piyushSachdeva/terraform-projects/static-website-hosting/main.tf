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

locals {
  s3_origin_id = "myS3Origin"
  my_domain    = "mydomain.com"
}
# Create a CloudFront origin access control (OAC) to restrict access to the S3 bucket
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "default-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# create cloudfront distribution to serve the content from s3 bucket

resource "aws_cloudfront_distribution" "s3_distribution" {

origin {
    domain_name              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name # THIS DOMAIN NAME TELLS Which S3 bucket CloudFront connects to. Tells CloudFront the domain name of the S3 bucket it should fetch content from. Terraform obtains the bucket's regional domain name from AWS. You don't have to manually type the S3 endpoint.
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id #Associates the S3 origin with the Origin Access Control (OAC) we create separately. It ensures that CloudFront can securely access the S3 bucket without exposing it to the public.
    origin_id                = local.s3_origin_id  #This is simply a label that identifies the origin inside the CloudFront distribution. It is not the bucket name.
  }
  enabled             = true # IT enables the distribution, allowing it to start serving content. SO THE USER CAN ACCESS THE CONTENT FROM THE DISTRIBUTION URL.
  is_ipv6_enabled     = true # Enables IPv6 support for the distribution, allowing clients to connect using IPv6 addresses.
  default_root_object = "index.html" #Which file CloudFront serves when someone opens the root URL . INDEX.HTML is the default file that CloudFront serves when a user accesses the root of the distribution's domain name. If you have a different default file, you can change this value accordingly.
  comment             = "Terraform S3 CloudFront Lab" #A descriptive note about the distribution

default_cache_behavior {
  target_origin_id       = local.s3_origin_id #This tells CloudFront which origin should serve the requested content.

  viewer_protocol_policy = "redirect-to-https" #This policy ensures that all HTTP requests are automatically redirected to HTTPS, enhancing security by enforcing encrypted connections.



  #This defines which HTTP methods CloudFront accepts for this behavior.
  #GET -> retrieves a file, such as index.html.
  #HEAD -> retrieves metadata about a file without downloading the file itself.
  allowed_methods = ["GET", "HEAD"]


   
  cached_methods  = ["GET", "HEAD"] #This specifies which methods CloudFront caches responses for. We're caching the responses for both GET and HEAD. These methods are also included in the allowed methods.



  cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # This is the ID of a predefined cache policy provided by AWS. It defines how CloudFront caches content, including which headers, cookies, and query strings to consider when caching.
  }

  #CloudFront supports geographic restrictions if you want to allow or block website access from specific countries.
restrictions {
  geo_restriction {
    restriction_type = "none"
    }
  }

  #This configures the certificate CloudFront uses for HTTPS connections between the visitor's browser and CloudFront.
  #For our lab, we're using the default CloudFront domain, ending in cloudfront.net.
viewer_certificate {
    cloudfront_default_certificate = true
  }
}





# #bucket policy to allow cloudfront to access the s3 bucket
# 
# Allow CloudFront to access objects in the private S3 bucket
data "aws_iam_policy_document" "cloudfront_policy" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.s3_distribution.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_policy.json
}





output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}