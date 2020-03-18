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
