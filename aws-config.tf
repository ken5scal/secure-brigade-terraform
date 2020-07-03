// AWS Confg it self was turned on by following script and manual.
// https://github.com/awslabs/aws-securityhub-multiaccount-scripts
// But DON'T USE THEM IN THE FUTURE
// After applying this terraform resource, execute following line in order to activate AWS Config recorders.
// `for i in "${REGIONS[@]}"; do echo "## Status of $i" && aws configservice put-configuration-recorder --configuration-recorder roleARN=arn:aws:iam::"$ACCOUNT":role/AWSConfigMgtRole,name=default --recording-group allSupported=true,includeGlobalResourceTypes=true --region=$i && aws configservice put-delivery-channel --delivery-channel name=config-s3-delivery,s3BucketName=aws-config-bucket-for-secure-brigade --region=$i ; done`

// Centrailized AWS Config recorder bucket
resource "aws_s3_bucket" "config-bucket" {
  provider = aws.compliance
  region   = var.region
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

resource "aws_kms_key" "config-bucket" {
  provider            = aws.compliance
  description         = "key to encrypt/decrypt s3 storing AWS Configs"
  enable_key_rotation = true
}

resource "aws_kms_alias" "config-bucket" {
  provider      = aws.compliance
  name          = "alias/config-bucket-key"
  target_key_id = aws_kms_key.config-bucket.key_id
}

resource "aws_iam_role" "org-aggregator" {
  name               = "AWSConfigAggregatorRole"
  path               = "/service-role/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "org-aggregator" {
  role       = aws_iam_role.org-aggregator.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

module "iam-config-mgt-master" {
  source                     = "./modules/aws-config"
  config-recorder-bucket-arn = aws_s3_bucket.config-bucket.arn
}

module "iam-config-mgt-compliance" {
  providers = {
    aws = aws.compliance
  }
  source                     = "./modules/aws-config"
  config-recorder-bucket-arn = aws_s3_bucket.config-bucket.arn
}

module "iam-config-mgt-stg" {
  providers = {
    aws = aws.stg
  }
  source                     = "./modules/aws-config"
  config-recorder-bucket-arn = aws_s3_bucket.config-bucket.arn
}

module "iam-config-mgt-prod" {
  providers = {
    aws = aws.prod
  }
  source                     = "./modules/aws-config"
  config-recorder-bucket-arn = aws_s3_bucket.config-bucket.arn
}

module "iam-config-mgt-security" {
  providers = {
    aws = aws.security
  }
  source                     = "./modules/aws-config"
  config-recorder-bucket-arn = aws_s3_bucket.config-bucket.arn
}
