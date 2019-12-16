data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                       = "secure-brigate-cloudtrail"
  s3_bucket_name             = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix              = "prefix"
  enable_log_file_validation = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
      "arn:aws:s3:::"]
    }
  }
}

resource "aws_kms_key" "key" {
  description = "key to encrypt/decrypt s3 storing cloudTrail"
}

resource "aws_kms_alias" "key-alias" {
  name          = "alias/cloudTrail-bucket-key"
  target_key_id = aws_kms_key.key.key_id
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = "cloudtail-bucket-secure-brigate"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.key.key_id
      }
    }
  }

  tags = {
    name = "cloudtail-bucket"
    env  = "logging"
    jobs = "cloudTrail"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::cloudtail-bucket-secure-brigate"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::cloudtail-bucket-secure-brigate/prefix/AWSLogs/${var.master-account-id}/*",
                "arn:aws:s3:::cloudtail-bucket-secure-brigate/prefix/AWSLogs/${var.compliance-account-id}/*",
                "arn:aws:s3:::cloudtail-bucket-secure-brigate/prefix/AWSLogs/${var.logging-account-id}/*",
                "arn:aws:s3:::cloudtail-bucket-secure-brigate/prefix/AWSLogs/${var.sandbox-account-id}/*",
                "arn:aws:s3:::cloudtail-bucket-secure-brigate/prefix/AWSLogs/${var.stg-account-id}/*",
                "arn:aws:s3:::cloudtail-bucket-secure-brigate/prefix/AWSLogs/${var.prod-account-id}/*",
                "arn:aws:s3:::cloudtail-bucket-secure-brigate/prefix/AWSLogs/${var.shared-resources-account-id}/*",
                "arn:aws:s3:::cloudtail-bucket-secure-brigate/prefix/AWSLogs/${var.security-account-id}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}