// ---------------------------------------
// S3 Settings in Compliance AWS Accounts
// ---------------------------------------
resource "aws_s3_bucket" "cloudtrail" {
  provider = aws.compliance
  bucket   = "secure-brigade-cloudtrail-log"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.cloudtrail-bucket.key_id
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log.id
    target_prefix = "log/"
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

    // intentionally not expiring.
    // if budget becomes tight, expiration day may be set
    //expiration {
    //  days = 90
    //}
  }

  // TODO FIX ME
  //  replication_configuration {
  //    role = aws_iam_role.cloudtrail-replicate-object.arn
  //
  //    rules {
  //      id     = "cloudtrail-logging"
  //      status = "Enabled"
  //
  //      source_selection_criteria {
  //        sse_kms_encrypted_objects {
  //          enabled = true
  //        }
  //      }
  //
  //      destination {
  //        bucket             = aws_s3_bucket.cloudtrail-replication.arn
  //        storage_class      = "STANDARD"
  //        replica_kms_key_id = aws_kms_key.cloudtrail-replication.arn
  //        access_control_translation {
  //          owner = "Destination"
  //        }
  //        account_id = lookup(var.accounts, "logging")
  //      }
  //    }
  //  }

  policy = data.aws_iam_policy_document.cloudtrail-log-bucket.json

  tags = {
    name   = "cloudtrail-log-bucket"
    env    = "compliance"
    source = "cloudtrail"
    jobs   = "audit"
  }
}

resource "aws_s3_bucket_public_access_block" "block-cloudtrail-logging" {
  provider                = aws.compliance
  bucket                  = aws_s3_bucket.cloudtrail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "cloudtrail-bucket" {
  provider            = aws.compliance
  description         = "key to encrypt/decrypt s3 storing cloudTrail"
  enable_key_rotation = true
}

resource "aws_kms_alias" "cloudtrail-bucket" {
  provider      = aws.compliance
  name          = "alias/cloudTrail-bucket-key"
  target_key_id = aws_kms_key.cloudtrail-bucket.key_id
}

resource "aws_s3_bucket" "log" {
  provider = aws.compliance
  bucket   = "cloudtail-bucket-access-log"
  acl      = "log-delivery-write"
}

resource "aws_s3_bucket_public_access_block" "block-log" {
  provider                = aws.compliance
  bucket                  = aws_s3_bucket.log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// ---------------------------------------
// S3 Settings in Logging AWS Accounts
// ---------------------------------------
resource "aws_s3_bucket" "cloudtrail-replication" {
  provider = aws.logging
  bucket   = "cloudtrail-replication-bucket"
  region   = var.region

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
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
    name   = "cloudtail-replication-bucket"
    env    = "logging"
    source = "cloudtrail-log-bucket"
    role   = "log-analysis"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail-replication" {
  provider                = aws.logging
  bucket                  = aws_s3_bucket.cloudtrail-replication.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "cloudtrail-replication" {
  provider            = aws.logging
  description         = "key to encrypt/decrypt replication of CloudTrail from logging account"
  enable_key_rotation = true
  policy              = <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${lookup(var.accounts, "logging")}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Enable cross account encrypt access for S3 Cross Region Replication",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${lookup(var.accounts, "compliance")}:root"
            },
            "Action": "kms:Encrypt",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_alias" "cloudtrail-replication" {
  provider      = aws.logging
  name          = "alias/cloudtrail-replication-storage-key"
  target_key_id = aws_kms_key.cloudtrail-replication.key_id
}
