data "aws_organizations_organization" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

data "aws_iam_policy_document" "cloudtrail-log-bucket" {
  statement {
    sid    = "AWSCloudTrailAclAndBucketCheck"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["s3:GetBucketAcl", "s3:ListBucket"]
    resources = ["arn:aws:s3:::secure-brigade-cloudtrail-log"]
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