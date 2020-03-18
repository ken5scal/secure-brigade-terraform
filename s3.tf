resource "aws_s3_bucket" "terraform-backend" {
  bucket = "secure-brigade-terraform-backend"
  region = var.region

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.terraform-backend.key_id
      }
    }
  }

  tags = {
    name = "terraform-backend"
    env  = "shared-resources"
    jobs = "config-mgt"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "block-terraform-backend" {
  bucket                  = aws_s3_bucket.terraform-backend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "terraform-backend" {
  description         = "key to encrypt/decrypt terraform backend in S3"
  enable_key_rotation = true
}

resource "aws_kms_alias" "terraform-backend" {
  name          = "alias/terraform-backend-key"
  target_key_id = aws_kms_key.terraform-backend.key_id
}

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
