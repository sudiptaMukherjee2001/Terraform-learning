output "Name_of_the_instance" {
     value = module.ec2_creation.instance_name
}
output "bucket_name" {
     value = module.s3_creation.s3Bucketname
}
