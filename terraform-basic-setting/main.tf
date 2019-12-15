resource "aws_s3_bucket" "terraform-backend" {
  bucket = "terraform-backend-secure-brigade"
  region = var.region

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.terraform-backend.key_id
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.terraform-backend-logging.id
  }

  tags = {
    name = "terraform-backend"
    env = "shared-resources"
    jobs = "config-mgt"
  }
}

resource "aws_s3_bucket_public_access_block" "block-terraform-backend" {
  bucket = aws_s3_bucket.terraform-backend.id
  block_public_acls = true
  block_public_policy = true
}

resource "aws_kms_key" "terraform-backend" {
  description = "key to encrypt/decrypt terraform backend in S3"
}

resource "aws_kms_alias" "terraform-backend" {
  name = "alias/terraform-backend-key"
  target_key_id = aws_kms_key.terraform-backend.key_id
}

// this bucket collects access log in terraform-backend s3.
// however, logging is only allowed in the s3 on the same aws account
// thus, any objects(logs) placed in this s3 is replicated to the s3 in aws-logging-account
resource "aws_s3_bucket" "terraform-backend-logging" {
  bucket = "terraform-backend-secure-brigade-logging"
  region = var.region
  acl = "log-delivery-write"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.terraform-backend.key_id
      }
    }
  }

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id = "terraform-logging"
      status = "Enabled"

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }

      destination {
        bucket = aws_s3_bucket.logging-replication.arn
        replica_kms_key_id = aws_kms_key.terraform-backend-logging-replication.arn
        access_control_translation {
          owner = "Destination"
        }
        account_id = var.logging-account-id
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    name = "terraform-backend-logging"
    env = "shared-resources"
    jobs = "config-mgt-log"
  }
}

resource "aws_s3_bucket_public_access_block" "block-terraform-backend-log" {
  bucket = aws_s3_bucket.terraform-backend-logging.id
  block_public_acls = true
  block_public_policy = true
}

resource "aws_iam_role" "replication" {
  name = "terraform-iam-role-replication"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  name = "terraform-iam-role-policy-replication"
  # Sid 1: Allow original bucket (or s3 as principal) can get replication config and List
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
         "Sid":"1",
         "Effect":"Allow",
         "Action": [
           "s3:GetReplicationConfiguration",
           "s3:ListBucket"
          ],
          "Resource":"${aws_s3_bucket.terraform-backend-logging.arn}"
      }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

// --------------------------------
// Settings in Logging AWS Accounts
// --------------------------------

resource "aws_s3_bucket" "logging-replication" {
  provider = aws.logging
  bucket = "terraform-backend-logging-replication"
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.terraform-backend-logging-replication.key_id
      }
    }
  }

  versioning {
    enabled = true
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }

  tags = {
    name = "terraform-backend-logging-replication"
    env = "logging"
    jobs = "config-mgt-log"
  }
}

resource "aws_s3_bucket_public_access_block" "block-terraform-backend-log-replication" {
  provider = aws.logging
  bucket = aws_s3_bucket.logging-replication.id
  block_public_acls = true
  block_public_policy = true
}

resource "aws_s3_bucket_policy" "terraform-backend-log-replication" {
  provider = aws.logging
  bucket = aws_s3_bucket.logging-replication.id
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "",
    "Statement": [
        {
            "Sid": "S3-Console-Replication-Policy",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.shared-resources-account-id}:root"
            },
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:GetBucketVersioning",
                "s3:PutBucketVersioning",
                "s3:ObjectOwnerOverrideToBucketOwner"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-backend-logging-replication/*",
                "arn:aws:s3:::terraform-backend-logging-replication"
            ]
        }
    ]
}
EOF
}

resource "aws_kms_key" "terraform-backend-logging-replication" {
  provider = aws.logging
  description = "key to encrypt/decrypt replication of logs in terraform backend"
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
                "AWS": "arn:aws:iam::${var.shared-resources-account-id}:root"
            },
            "Action": "kms:Encrypt",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_alias" "terraform-backend-logging-replication" {
  provider = aws.logging
  name = "alias/terraform-backend-logging-replicationkey"
  target_key_id = aws_kms_key.terraform-backend-logging-replication.key_id
}