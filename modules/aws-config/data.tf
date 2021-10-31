data "aws_iam_policy_document" "aws-config-assume-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "transfer-record" {
  statement {
    effect  = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      var.config_recorder_bucket_arn,
      "${var.config_recorder_bucket_arn}/*"
    ]
  }
}
