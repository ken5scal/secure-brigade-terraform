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
  description         = "key to encrypt/decrypt terraform backend in S3"
  enable_key_rotation = true
}

resource "aws_kms_alias" "terraform-backend" {
  name          = "alias/terraform-backend-key"
  target_key_id = aws_kms_key.terraform-backend.key_id
}

module "terraform-administrator-in-logging" {
  providers = {
    aws = aws.logging
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administrating"
  env                      = "logging"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

data "aws_iam_policy" "administrator-access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
