resource "aws_s3_bucket" "terraform-backend" {
  bucket = "terraform-backend-secure-brigade"
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
  description = "key to encrypt/decrypt terraform backend in S3"
}

resource "aws_kms_alias" "terraform-backend" {
  name          = "alias/terraform-backend-key"
  target_key_id = aws_kms_key.terraform-backend.key_id
}