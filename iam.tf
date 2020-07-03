resource "aws_iam_role" "cloudtrail-servie" {
  name               = "SecureBrigadeCloudTrailServiceRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "cloudtrail-to-cw-log" {
  role   = aws_iam_role.cloudtrail-servie.name
  name   = "SendCloudTrailLogToCloudWatchLogPolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:CloudTrailLogs:log-stream:*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role" "azure-sentinel" {
  name = "AzureSentinelRole"
  // https://docs.microsoft.com/en-us/azure/sentinel/connect-aws
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::197857026523:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "3c38da68-f848-4cfe-a698-0d61050d3be2"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "azure-sentinel" {
  role       = aws_iam_role.azure-sentinel.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrailReadOnlyAccess"
}

// -------------------------------------
// Terraform Role in each AWS account
// -------------------------------------
module "terraform-administrator-in-master" {
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "master"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-compliance" {
  providers = {
    aws = aws.compliance
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "compliance"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-stg" {
  providers = {
    aws = aws.stg
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "stg"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-prod" {
  providers = {
    aws = aws.prod
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "prod"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-security" {
  providers = {
    aws = aws.security
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "security"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

// --------------------
// Password Policy
// --------------------
module "password-policy-master" {
  source = "./modules/iam-user-password-policy"
}

module "password-policy-security" {
  providers = {
    aws = aws.security
  }
  source = "./modules/iam-user-password-policy"
}

module "password-policy-compliance" {
  providers = {
    aws = aws.compliance
  }
  source = "./modules/iam-user-password-policy"
}

module "password-policy-stg" {
  providers = {
    aws = aws.stg
  }
  source = "./modules/iam-user-password-policy"
}

module "password-policy-prod" {
  providers = {
    aws = aws.prod
  }
  source = "./modules/iam-user-password-policy"
}

// --------------------
// AWS Incident Management Role with AWS Support
// probably just disable the benchmark
// https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-1.20
// --------------------
module "incident-manage-role-master" {
  source     = "./modules/support-roles"
  account-id = lookup(var.accounts, "master")
}

module "incident-manage-role-security" {
  providers = {
    aws = aws.security
  }
  source     = "./modules/support-roles"
  account-id = lookup(var.accounts, "security")
}

module "incident-manage-role-compliance" {
  providers = {
    aws = aws.compliance
  }
  source     = "./modules/support-roles"
  account-id = lookup(var.accounts, "compliance")
}

module "incident-manage-role-stg" {
  providers = {
    aws = aws.stg
  }
  source     = "./modules/support-roles"
  account-id = lookup(var.accounts, "stg")
}

module "incident-manage-role-prod" {
  providers = {
    aws = aws.prod
  }
  source     = "./modules/support-roles"
  account-id = lookup(var.accounts, "prod")
}