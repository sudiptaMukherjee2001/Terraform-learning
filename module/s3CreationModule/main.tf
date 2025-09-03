resource "aws_s3_bucket" "example" {
  bucket = "${var.bucket_names}-${terraform.workspace}"

  tags = {
    Name        = var.bucket_names
    Environment = var.environment
  }
}