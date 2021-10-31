module "iam-config-mgt-master" {
  source                      = "./modules/aws-config"
  config_recorder_name        = "config-s3-delivery"
  config_recorder_bucket_name = aws_s3_bucket.config-bucket.bucket
  config_recorder_bucket_arn  = aws_s3_bucket.config-bucket.arn
}

module "iam-config-mgt-compliance" {
  providers = { aws = aws.compliance }

  source                      = "./modules/aws-config"
  config_recorder_name        = "config-s3-delivery"
  config_recorder_bucket_name = aws_s3_bucket.config-bucket.bucket
  config_recorder_bucket_arn  = aws_s3_bucket.config-bucket.arn
}

module "iam-config-mgt-stg" {
  providers = { aws = aws.stg }

  source                      = "./modules/aws-config"
  config_recorder_name        = "config-s3-delivery"
  config_recorder_bucket_name = aws_s3_bucket.config-bucket.bucket
  config_recorder_bucket_arn  = aws_s3_bucket.config-bucket.arn
}

module "iam-config-mgt-prod" {
  providers = { aws = aws.prod }

  source                      = "./modules/aws-config"
  config_recorder_name        = "config-s3-delivery"
  config_recorder_bucket_name = aws_s3_bucket.config-bucket.bucket
  config_recorder_bucket_arn  = aws_s3_bucket.config-bucket.arn
}

module "iam-config-mgt-security" {
  providers = { aws = aws.security }

  source                      = "./modules/aws-config"
  config_recorder_name        = "config-s3-delivery"
  config_recorder_bucket_name = aws_s3_bucket.config-bucket.bucket
  config_recorder_bucket_arn  = aws_s3_bucket.config-bucket.arn
}
