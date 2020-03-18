terraform {
  required_version = "~> 0.12"

  required_providers {
    aws = "~> 2.42"
  }

  backend "s3" {
    // aws(shared-resources) profile in ~/.aws/credentials
    // profile is not required as long as AWS ENV is set.
    bucket       = "secure-brigade-terraform-backend"
    key          = "terraform-basic-setting/terraform.tfstate"
    kms_key_id   = "arn:aws:kms:ap-northeast-1:791325445011:key/339c67a9-50ac-4dfb-96cb-719c89bb6d34"
    encrypt      = true
    region       = "ap-northeast-1"
    session_name = "terraform-backend"
  }
}
