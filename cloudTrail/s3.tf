provider "aws" {
  alias = "logging"
  region = "ap-northeast-1"
  profile = "817939479605_AdministratorAccess" // aws(logging) profile in ~/.aws/credentials
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  provider = "aws.logging"
  bucket = "cloudtail-bucket-secure-brigate"

  logging {
    target_bucket = aws_s3_bucket.cloudtrail_log_bucket.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket" "cloudtrail_log_bucket" {
  provider = "aws.logging"
  bucket = "cloudtrail-log-bucket--secure-brigate"
  acl = "log-delivery-write"
}