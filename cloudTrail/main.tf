resource "aws_cloudtrail" "master" {
  name                       = "cloudtrail-master"
  s3_bucket_name             = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail      = true
  is_organization_trail      = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail-servie.arn
  kms_key_id                 = aws_kms_key.cloudtrail.arn

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

resource "aws_cloudwatch_log_group" "cloudtrail" {
  // Cloud Watch Log must be in the same account as sending CloudTrail
  name              = "CloudTrailLogs"
  retention_in_days = 7

  tags = {
    Name   = "CloudTrailLogs"
    Env    = "master"
    Source = "CloudTrail"
    jobs   = "log-analysis"
  }
}

resource "aws_kms_key" "cloudtrail" {
  description         = "key to encrypt/decrypt cloud to encrypt the logs delivered by CloudTrail"
  enable_key_rotation = true
  policy              = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::791325445011:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow CloudTrail to encrypt logs",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "kms:GenerateDataKey*",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${lookup(var.accounts, "master")}:trail/*"
                }
            }
        },
        {
          "Sid": "Allow CloudTrail access",
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "kms:DescribeKey",
          "Resource": "*"
        },
        {
          "Sid": "Enable encrypted CloudTrail log read access",
          "Effect": "Allow",
          "Principal": {
            "AWS": [
              "arn:aws:iam::${lookup(var.accounts, "compliance")}:root"
            ]
          },
          "Action": "kms:Decrypt",
          "Resource": "*",
          "Condition": {
            "Null": {
              "kms:EncryptionContext:aws:cloudtrail:arn": "false"
            }
          }
        }
    ]
}
EOF
  tags = {
    Name = "KeyForCloudTrailLogEncryption"
    Env  = "master"
    jobs = "Audit"
  }
}

resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/cloudTrail-log-key"
  target_key_id = aws_kms_key.cloudtrail.key_id
}
