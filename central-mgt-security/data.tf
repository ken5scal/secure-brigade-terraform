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
    actions = ["guardduty:*"]
    resources = ["*"]
    effect = "Allow"
  }
}