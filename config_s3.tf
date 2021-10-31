// Centrailized AWS Config recorder bucket
resource "aws_s3_bucket" "config-bucket" {
  provider = aws.compliance
  bucket   = "secure-brigade-aws-config-bucket"

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

    expiration {
      days = 90
    }
  }

  tags = {
    name   = "aws-config-bucket"
    env    = "compliance"
    source = "AWS Config"
    jobs   = "config-mgt"
  }
}

resource "aws_s3_bucket_policy" "config-bucket" {
  provider = aws.compliance
  bucket   = aws_s3_bucket.config-bucket.id
  policy   = data.aws_iam_policy_document.config-recorder.json
}

resource "aws_s3_bucket_public_access_block" "config-bucket" {
  provider                = aws.compliance
  bucket                  = aws_s3_bucket.config-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}