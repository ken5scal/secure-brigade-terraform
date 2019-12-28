data "aws_iam_policy_document" "aws-centralized-security-master" {
  statement {
    actions = [
    "sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
      "arn:aws:iam::${lookup(var.accounts, "security")}:root"]
    }
  }
}
data "aws_iam_policy_document" "initializer" {
  statement {
    actions = [
    "iam:CreateServiceLinkedRole"]
    resources = [
    "*"]
    effect = "Allow"
    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values = [
        "securityhub.amazonaws.com",
        "config.amazonaws.com",
        "guardduty.amazonaws.com"
      ]
    }
  }

  statement {
    actions = [
    "securityhub:*"]
    resources = [
    "*"]
    effect = "Allow"
  }

  statement {
    actions = [
      "config:DescribeConfigurationRecorders",
      "config:DescribeDeliveryChannels",
      "config:DescribeConfigurationRecorderStatus",
      "config:DeleteConfigurationRecorder",
      "config:DeleteDeliveryChannel",
      "config:PutConfigurationRecorder",
      "config:PutDeliveryChannel",
      "config:StartConfigurationRecorder"
    ]
    resources = [
    "*"]
    effect = "Allow"
  }

  statement {
    actions = [
    "iam:PassRole"]
    resources = [
    "arn:aws:iam::*:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:CreateBucket",
      "s3:PutBucketPolicy",
      "s3:ListBucket"
    ]
    resources = [
    "arn:aws:s3:::config-bucket-*"]
    effect = "Allow"
  }

  statement {
    actions = [
    "guardduty:*"]
    resources = [
    "*"]
    effect = "Allow"
  }
}

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
      "s3:GetBucketAcl"
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
