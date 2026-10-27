# Terraform with AWS IAM User Authentication

## Objective

Configure Terraform to authenticate to AWS using a dedicated IAM user instead of the AWS root user.

In this lab, we will:

1. Create an IAM user and grant the required permissions.
2. Create access keys for CLI authentication.
3. Configure AWS CLI using a named profile.
4. Verify the IAM identity.
5. Configure the Terraform AWS provider.
6. Create AWS resources using Terraform.
7. Verify the identity through AWS CloudTrail.

## Prerequisites

- An AWS account.
- An IAM user with the required AWS permissions.
- AWS CLI installed.
- Terraform installed.
- An AWS region selected for the lab.

## Step 1: Create an IAM User

1. Sign in to the AWS Management Console.
2. Open **IAM → Users → Create user**.
3. Enter a username, for example, `terraform-user-personal`.
4. Enable console access if required.
5. Create the user.
6. Attach the permissions required for the Terraform resources.

For this lab, `AdministratorAccess` was used. In production, follow the company's least-privilege access policy.

## Step 2: Create Access Keys

1. Open **IAM → Users → terraform-user-personal**.
2. Select **Security credentials**.
3. Find the **Access keys** section.
4. Click **Create access key**.
5. Select the appropriate CLI/local-development use case.
6. Create the access key and securely save the access key ID and secret access key.

**Security:** Never commit access keys or secret keys to GitHub. Do not store credentials in Terraform files.

## Step 3: Configure AWS CLI

Configure a named AWS CLI profile:

```bash
aws configure --profile terraform-user-personal
```

Enter the requested values:

```text
AWS Access Key ID: <IAM_ACCESS_KEY_ID>
AWS Secret Access Key: <IAM_SECRET_ACCESS_KEY>
Default region name: us-east-2
Default output format: json
```

Replace the placeholders with your IAM user's credentials.

AWS CLI stores the profile configuration locally. The credentials are normally stored in `~/.aws/credentials`, while profile settings are stored in `~/.aws/config`.

## Step 4: Verify the IAM Identity

Run:

```bash
aws sts get-caller-identity \
  --profile terraform-user-personal
```

Expected output (example):

```json
{
  "UserId": "AIDAXXXXXXXXXXXXXXXX",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/terraform-user-personal"
}
```

Verify that the ARN identifies the intended IAM user, not the root user.

To list configured AWS CLI profiles:

```bash
aws configure list-profiles
```

## Step 5: Configure Terraform

Create or update `provider.tf` in your Terraform project:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "terraform-user-personal"
}
```

### Explanation

- `region`: The AWS region where Terraform will manage resources.
- `profile`: The AWS CLI profile Terraform should use.
- `required_providers`: Specifies the AWS provider dependency.

The `profile` setting tells Terraform to use the credentials configured for `terraform-user-personal`.

Do not put access keys directly in Terraform configuration.

## Step 6: Initialize Terraform

From the Terraform project directory, run:

```bash
terraform init
```

This initializes the working directory and downloads the required providers.

## Step 7: Validate the Configuration

```bash
terraform validate
```

This checks whether the Terraform configuration is syntactically valid and internally consistent.

## Step 8: Review the Execution Plan

```bash
terraform plan
```

Review the proposed changes before applying them. Confirm the selected region and the resources Terraform intends to create, modify, or destroy.

## Step 9: Create AWS Resources

After reviewing the plan, run:

```bash
terraform apply
```

Terraform displays the proposed changes and asks for confirmation. Enter:

```text
yes
```

Terraform will attempt to create the configured resources using the IAM user's permissions.

## Step 10: Verify the Created Resources

For example, to list EC2 instances in the selected region:

```bash
aws ec2 describe-instances \
  --profile terraform-user-personal \
  --region us-east-2 \
  --query 'Reservations[].Instances[].InstanceId'
```

The output lists instance IDs visible to the IAM user in that region.

## Step 11: Verify the Identity Using CloudTrail

1. Open the AWS CloudTrail console.
2. Select **Event history**.
3. Filter for the event name `RunInstances` when verifying EC2 launches.
4. Open the event corresponding to your Terraform apply.
5. Inspect the event record.

Important fields include:

| Field | Purpose |
|---|---|
| `eventName` | Identifies the API operation, such as `RunInstances` |
| `userIdentity.type` | Identifies the principal type |
| `userIdentity.arn` | Shows the IAM user or role making the request |
| `userIdentity.userName` | Shows the IAM username when applicable |
| `userAgent` | May indicate Terraform and its AWS provider |

Confirm that the event's timestamp, region, and resource identifiers correspond to your Terraform run.

## Switching Between AWS CLI Profiles

Check the default profile:

```bash
aws sts get-caller-identity
```

Check the named IAM profile:

```bash
aws sts get-caller-identity \
  --profile terraform-user-personal
```

These commands do not change the profiles. Each command uses the specified profile, or the default profile if none is specified.

## Important Notes

- Logging in to the AWS Console as an IAM user does not automatically change the AWS CLI identity.
- AWS CLI profiles provide separate credential configurations.
- Terraform must authenticate using the intended profile or another approved credential mechanism.
- AWS resources belong to the AWS account and region, not exclusively to the user who created them.
- CloudTrail can help identify the principal that made an AWS API request.
- Avoid using the root user for routine Terraform operations.
- In company environments, follow the approved authentication method. Companies may use IAM Identity Center, assumed roles, or temporary credentials instead of IAM access keys.
- Run `terraform destroy` only when you intentionally want to remove the resources managed by the current Terraform configuration. Review the plan carefully before confirming.

## Conclusion

This lab demonstrates how to configure AWS CLI with a named IAM profile, authenticate Terraform using that profile, create AWS resources, and verify the identity responsible for an API request using CloudTrail.
