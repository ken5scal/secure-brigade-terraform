# Cloud Trail Settings
resource "aws_cloudtrail" "logging" {
  name = "cloudtrail-logging"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail = true

  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"]
    }
  }
}

resource "aws_cloudtrail" "master" {
  provider = aws.master
  name = "cloudtrail-master"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail = true

  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"]
    }
  }
}

resource "aws_cloudtrail" "compliance" {
  provider = aws.compliance
  name = "cloudtrail-compliance"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail = true

  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"]
    }
  }
}

resource "aws_cloudtrail" "sandbox" {
  provider = aws.sandbox
  name = "cloudtrail-sandbox"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail = true

  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"]
    }
  }
}

resource "aws_cloudtrail" "stg" {
  provider = aws.stg
  name = "cloudtrail-stg"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail = true

  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"]
    }
  }
}

resource "aws_cloudtrail" "prod" {
  provider = aws.prod
  name = "cloudtrail-prod"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail = true

  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"]
    }
  }
}

resource "aws_cloudtrail" "shared-resources" {
  provider = aws.shared-resources
  name = "cloudtrail-shared-resource"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail = true

  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"]
    }
  }
}

resource "aws_cloudtrail" "security" {
  provider = aws.security
  name = "cloudtrail-security"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail = true

  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"]
    }
  }
}

// ---------------------------------------
// S3 Settings in Compliance AWS Accounts
// ---------------------------------------
resource "aws_s3_bucket" "cloudtrail" {
  provider = aws.compliance
  bucket = "cloudtail"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.cloudtrail.key_id
      }
    }
  }

  lifecycle_rule {
    enabled = true

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 60
      storage_class = "GLACIER"
    }
  }

  replication_configuration {
    role = aws_iam_role.cloudtrail.arn

    rules {
      id = "cloudtrail-logging"
      status = "Enabled"

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }

      destination {
        bucket = aws_s3_bucket.cloudtrail-replication.arn
        storage_class = "STANDARD"
        replica_kms_key_id = aws_kms_key.cloudtrail-replication.arn
        access_control_translation {
          owner = "Destination"
        }
        account_id = var.logging-account-id
      }
    }
  }

  tags = {
    name = "cloudtail-bucket"
    env = "compliance"
    source = "CloudTrail"
    jobs = "audit-trail"
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
            "Resource": "arn:aws:s3:::cloudtail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::cloudtail/AWSLogs/${lookup(var.accounts, "master")}/*",
                "arn:aws:s3:::cloudtail/AWSLogs/${lookup(var.accounts, "compliance")}/*",
                "arn:aws:s3:::cloudtail/AWSLogs/${lookup(var.accounts, "sandbox")}/*",
                "arn:aws:s3:::cloudtail/AWSLogs/${lookup(var.accounts, "logging")}/*",
                "arn:aws:s3:::cloudtail/AWSLogs/${lookup(var.accounts, "stg")}/*",
                "arn:aws:s3:::cloudtail/AWSLogs/${lookup(var.accounts, "prod")}/*",
                "arn:aws:s3:::cloudtail/AWSLogs/${lookup(var.accounts, "shared-resources")}/*",
                "arn:aws:s3:::cloudtail/AWSLogs/${lookup(var.accounts, "security")}/*"
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

resource "aws_s3_bucket_public_access_block" "block-cloudtrail-logging" {
  provider = aws.compliance
  bucket = aws_s3_bucket.cloudtrail.id
  block_public_acls = true
  block_public_policy = true
}

resource "aws_kms_key" "cloudtrail" {
  provider = aws.compliance
  description = "key to encrypt/decrypt s3 storing cloudTrail"
}

resource "aws_kms_alias" "cloudtrail" {
  provider = aws.compliance
  name = "alias/cloudTrail-bucket-key"
  target_key_id = aws_kms_key.cloudtrail.key_id
}

// ---------------------------------------
// S3 Settings in Logging AWS Accounts
// ---------------------------------------
resource "aws_s3_bucket" "cloudtrail-replication" {
  bucket = "cloudtrail-replication-bucket"
  region = var.region

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.cloudtrail-replication.key_id
      }
    }
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }

  tags = {
    name = "cloudtail-bucket"
    env = "logging"
    source = "CloudTrail in compliance account"
    jobs = "audit-trail"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail-replication" {
  bucket = aws_s3_bucket.cloudtrail-replication.id
  block_public_acls = true
  block_public_policy = true
}

resource "aws_kms_key" "cloudtrail-replication" {
  description = "key to encrypt/decrypt replication of CloudTrail from logging account"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.logging-account-id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Enable cross account encrypt access for S3 Cross Region Replication",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.compliance-account-id}:root"
            },
            "Action": "kms:Encrypt",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_alias" "cloudtrail-replication" {
  name = "alias/cloudtrail-replication-storage-key"
  target_key_id = aws_kms_key.cloudtrail-replication.key_id
}

