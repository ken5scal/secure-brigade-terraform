terraform {
  required_version = "~> 0.12"

  required_providers {
    aws = "~> 2.42"
  }

  backend "s3" {
    // aws(shared-resources) profile in ~/.aws/credentials
    profile    = "584423914806_AdministratorAccess"
    bucket     = "terraform-backend-secure-brigade"
    key        = "${var.application}/${var.environment}.tfstate"
    kms_key_id = "arn:aws:kms:ap-northeast-1:584423914806:key/ffca358f-a093-42ce-a2de-45d16c0a9610"
    encrypt    = true
    region     = "ap-northeast-1"
  }
}
