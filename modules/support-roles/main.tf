terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

// https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-1.20
resource "aws_iam_role" "aws-incident-manage-role" {
  name               = "AWSIncidentMangeRoleWithAWSSupport"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": ["arn:aws:iam::${var.account-id}:root"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.aws-incident-manage-role.name
  policy_arn = data.aws_iam_policy.aws-support-access.arn
}

variable "account-id" {
  description = "aws acccount id where the assumption (sts) is conducted"
}

data "aws_iam_policy" "aws-support-access" {
  arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}