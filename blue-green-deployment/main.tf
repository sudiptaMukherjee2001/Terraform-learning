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


# Add this block to fix the "aws_caller_identity" error
data "aws_caller_identity" "current" {}

# Add this block if you are also referencing the region dynamically
data "aws_region" "current" {}

# CREATING THE ROLE FOR SERVICE ROLE
# THIS BLOCK WILL GENERATE JSON FORMAT . SO THAT THIS JSON CAN BE USED BY THE assume_role_policy ATTRIBUTE IN THE aws_iam_role RESOURCE
data "aws_iam_policy_document" "elasticbeanstalk-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eb_service_role" {
  name               = "elasticbeanstalk-service-role"
  assume_role_policy = data.aws_iam_policy_document.elasticbeanstalk-assume-role.json // assume_role_policy IS BASICALLY THE TRUST POLICY THAT DEFINES WHO WILL USE THIS ROLE
}

# Attaching the managed policy to the service role 
resource "aws_iam_role_policy_attachment" "enhanced_health" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "managed_updates" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}

# Role for EC2 instances

data "aws_iam_policy_document" "ec2-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2-role" {
  name               = "ec2-compute-role"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role.json
}

resource "aws_iam_role_policy_attachment" "multicontainter_docker_policy" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}


resource "aws_iam_role_policy_attachment" "web_tier_policy" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "worker_tier_policy" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}


# instance profile for EC2 instances - Required for the EC2 instances to use the role and access AWS resources
resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "elasticbeanstalk-ec2-role"
  role = aws_iam_role.ec2-role.name
}



# Creating the beanstalk application - blue env - production environment

resource "aws_elastic_beanstalk_application" "Blue-application" {
  name        = "Blue-green-application-name-activeBlue"
  description = "This is a blue-green deployment application"
  tags = {
    Environment = "Production"
  }
}

# creating the beanstalk environment
resource "aws_elastic_beanstalk_environment" "Blue-application-environment" {
  name                = "Blue-env-serving-traffic"
  application         = aws_elastic_beanstalk_application.Blue-application.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.13.2 running PHP 8.2"
  tier                = "WebServer"
  version_label       = aws_elastic_beanstalk_application_version.v1.name # This line ensures that the environment is associated with the specific application version you created.

  # 1. LINK THE INSTANCE PROFILE (Fixes your specific error)
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  # 2. LINK THE SERVICE ROLE (Required for proper management and health updates)
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.name
  }
}



resource "aws_s3_object" "appv1-blue-active" {
  bucket = "elasticbeanstalk-${data.aws_region.current.region}-${data.aws_caller_identity.current.account_id}"
  key    = "app-v1.zip"
  # source = "app-v1.zip"
  source = "app-v1.zip"
 
}


# Create the application version in Elastic Beanstalk using the S3 object
resource "aws_elastic_beanstalk_application_version" "v1" {
  name        = "app-v1"
  application = aws_elastic_beanstalk_application.Blue-application.name
  description = "Application Version 1.0 - Initial Release"
  bucket      = aws_s3_object.appv1-blue-active.bucket
  key         = aws_s3_object.appv1-blue-active.key
}


# Creating the beanstalk application - green env - in-progress environment

resource "aws_elastic_beanstalk_application" "Green-application" {
  name        = "Blue-green-application-name-inprogress"
  description = "This is a blue-green deployment application"
  tags = {
    Environment = "In-progress"
  }
}

# creating the beanstalk environment
resource "aws_elastic_beanstalk_environment" "Green-application-environment" {
  name                = "green-env-inprogress"
  application         = aws_elastic_beanstalk_application.Green-application.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.13.2 running PHP 8.2"
  tier                = "WebServer"
  version_label       = aws_elastic_beanstalk_application_version.v2.name # This line ensures that the environment is associated with the specific application version you created.

  # 1. LINK THE INSTANCE PROFILE (Fixes your specific error)
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  # 2. LINK THE SERVICE ROLE (Required for proper management and health updates)
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.name
  }
}



resource "aws_s3_object" "appv1-green-inprogress" {
  bucket = "elasticbeanstalk-${data.aws_region.current.region}-${data.aws_caller_identity.current.account_id}"
  key    = "app--v2.zip"
  # source = "app-v1.zip"
  source = "app--v2.zip"
  #etag   = filemd5("app--v2.zip")
}


# Create the application version in Elastic Beanstalk using the S3 object
resource "aws_elastic_beanstalk_application_version" "v2" {
  name        = "app-v2"
  application = aws_elastic_beanstalk_application.Green-application.name
  description = "Application Version 2.0 - Updated Release"
  bucket      = aws_s3_object.appv1-green-inprogress.bucket
  key         = aws_s3_object.appv1-green-inprogress.key
}