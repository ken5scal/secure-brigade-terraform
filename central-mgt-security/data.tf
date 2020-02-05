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
        module.iam-config-mgt-sandbox.iam-arn,
        module.iam-config-mgt-logging.iam-arn,
        module.iam-config-mgt-stg.iam-arn,
        module.iam-config-mgt-prod.iam-arn,
        module.iam-config-mgt-shared-resources.iam-arn,
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
        module.iam-config-mgt-sandbox.iam-arn,
        module.iam-config-mgt-logging.iam-arn,
        module.iam-config-mgt-stg.iam-arn,
        module.iam-config-mgt-prod.iam-arn,
        module.iam-config-mgt-shared-resources.iam-arn,
        module.iam-config-mgt-security.iam-arn
      ]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "master")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "compliance")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "sandbox")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "logging")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "stg")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "prod")}/Config/*",
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "shared-resources")}/Config/*",
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
