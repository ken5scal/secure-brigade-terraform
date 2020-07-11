data "aws_organizations_organization" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

data "aws_iam_policy" "administrator-access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "cloudtrail-log-bucket" {
  statement {
    sid    = "AWSCloudTrailAclAndBucketCheck"
    effect = "Allow"
    principals {
      identifiers = [
      "cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "s3:GetBucketAcl",
    "s3:ListBucket"]
    resources = [
    "arn:aws:s3:::secure-brigade-cloudtrail-log"]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    principals {
      identifiers = [
      "cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = [
    "s3:PutObject"]
    resources = [
      "arn:aws:s3:::secure-brigade-cloudtrail-log/AWSLogs/${lookup(var.accounts, "master")}/*",
      "arn:aws:s3:::secure-brigade-cloudtrail-log/AWSLogs/${data.aws_organizations_organization.this.id}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
      "bucket-owner-full-control"]
    }
  }
}

data "aws_iam_policy_document" "config-recorder" {
  statement {
    sid    = "AWSConfigBucketPermissionAndExistenceCheck"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
      "config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.config-bucket.arn
    ]
  }
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        module.iam-config-mgt-master.iam-arn,
        module.iam-config-mgt-compliance.iam-arn,
        module.iam-config-mgt-stg.iam-arn,
        module.iam-config-mgt-prod.iam-arn,
        module.iam-config-mgt-security.iam-arn
      ]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.config-bucket.arn
    ]
  }

  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        module.iam-config-mgt-master.iam-arn,
        module.iam-config-mgt-compliance.iam-arn,
        module.iam-config-mgt-stg.iam-arn,
        module.iam-config-mgt-prod.iam-arn,
        module.iam-config-mgt-security.iam-arn
      ]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "master")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "compliance")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "stg")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "prod")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "security")}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

data "aws_iam_policy_document" "use-kms-terraform-backend-key" {
  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.terraform-backend.arn
    ]
  }
}