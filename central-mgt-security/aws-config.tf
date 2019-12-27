// AWS Confg it self was turned on by following script and manual.
// https://github.com/awslabs/aws-securityhub-multiaccount-scripts

// Centrailized AWS Config recorder bucket
resource "aws_s3_bucket" "config-bucket" {
  provider = aws.shared-resources
  region   = var.region
  bucket   = "aws-config-bucket-for-secure-brigade"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.config-bucket.key_id
      }
    }
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  tags = {
    name   = "aws-config-bucket"
    env    = "shared-resources"
    source = "AWS Config"
    jobs   = "config-mgt"
  }
}

resource "aws_s3_bucket_public_access_block" "config-bucket" {
  provider            = aws.shared-resources
  bucket              = aws_s3_bucket.config-bucket.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_kms_key" "config-bucket" {
  provider    = aws.shared-resources
  description = "key to encrypt/decrypt s3 storing AWS Configs"
}

resource "aws_kms_alias" "config-bucket" {
  provider      = aws.shared-resources
  name          = "alias/config-bucket-key"
  target_key_id = aws_kms_key.config-bucket.key_id
}

resource "aws_s3_bucket_policy" "config-bucket" {
  provider = aws.shared-resources
  bucket   = aws_s3_bucket.config-bucket.id
  policy   = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::aws-config-bucket-for-secure-brigade"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::aws-config-bucket-for-secure-brigade/AWSLogs/${lookup(var.accounts, "shared-resources")}/Config/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_role.config-mgt.arn}"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::aws-config-bucket-for-secure-brigade"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_role.config-mgt.arn}"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::aws-config-bucket-for-secure-brigade/AWSLogs/${lookup(var.accounts, "security")}/Config/*",
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

// in security account
resource "aws_iam_role" "config-mgt" {
  name               = "AWSConfigMgtRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "get-config" {
  role = aws_iam_role.config-mgt.name
  // predefined policy
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_policy" "transfer-record" {
  name   = "AWSConfigRecordTransferPolicy"
  role   = aws_iam_role.config-mgt.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "${aws_s3_bucket.config-bucket.arn}/*"
        }
    ]
}
POLICY
}
