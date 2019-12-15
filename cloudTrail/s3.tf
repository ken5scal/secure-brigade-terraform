provider "aws" {
  alias = "logging"
  region = "ap-northeast-1"
  profile = "817939479605_AdministratorAccess" // aws(logging) profile in ~/.aws/credentials
}

//terraform {
//  backend "s3" {
//    bucket = "terraform-backend-secure-brigade"
//    key    = "cloudTrail/terraform.tfstate"
//    profile = "584423914806_AdministratorAccess" // aws(shared-resources) profile in ~/.aws/credentials
//    encrypt = true
//    kms_key_id = "arn:aws:kms:ap-northeast-1:817939479605:key/95116356-3c53-4770-abc1-95173fcacea1"
//    region = "ap-northeast-1"
//  }
//}

//resource "aws_s3_bucket" "cloudtrail_bucket" {
//  provider = "aws.logging"
//  bucket = "cloudtail-bucket-secure-brigate"
//
//  logging {
//    target_bucket = aws_s3_bucket.cloudtrail_log_bucket.id
//    target_prefix = "log/"
//  }
//}
//
//resource "aws_s3_bucket" "cloudtrail_log_bucket" {
//  provider = "aws.logging"
//  bucket = "cloudtrail-log-bucket--secure-brigate"
//  acl = "log-delivery-write"
//}