data "aws_iam_policy_document" "config-recorder" {
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
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      module.iam-config-mgt-master.iam-arn]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "master")}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }


  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      module.iam-config-mgt-compliance.iam-arn]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "compliance")}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      module.iam-config-mgt-sandbox.iam-arn]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "sandbox")}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      module.iam-config-mgt-logging.iam-arn]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "logging")}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      module.iam-config-mgt-stg.iam-arn]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "stg")}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      module.iam-config-mgt-prod.iam-arn]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "prod")}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      module.iam-config-mgt-shared-resources.iam-arn]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.config-bucket.arn}/AWSLogs/${lookup(var.accounts, "shared-resources")}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      module.iam-config-mgt-security.iam-arn]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
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
