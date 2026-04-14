provider "aws" {
  region = "us-east-2"
}


#Bucket Creation usign count meta argument
resource "aws_s3_bucket" "bucket1" {
  count = length(var.bucket_name_list)# here index will be generated based on the length of the list provided in the variable
  bucket = var.bucket_name_list[count.index] # var.bucket_name_list[0] will be the first bucket name, var.bucket_name_list[1] will be the second bucket name and so on
}


#Bucket Creation usign for_each  meta argument with set of strings
resource "aws_s3_bucket" "bucket2" {
  for_each=var.bucket_name_set // here index does not matter as we are using for_each with set of strings, so each bucket name will be treated as a unique key in the for_each loop
  bucket = each.key // in set of string both key and value will be same as we are using set of strings, so each.key will give us the bucket name directly
}