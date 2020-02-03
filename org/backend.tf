terraform {
  required_version = "~> 0.12"

  required_providers {
    aws = "~> 2.42"
  }

  backend "s3" {
    // aws(shared-resources) profile in ~/.aws/credentials
    // profile is not required as long as AWS ENV is set.
    bucket       = "terraform-backend-secure-brigade"
    key          = "org/terraform.tfstate"
    kms_key_id   = "arn:aws:kms:ap-northeast-1:584423914806:key/ffca358f-a093-42ce-a2de-45d16c0a9610"
    encrypt      = true
    region       = "ap-northeast-1"
    role_arn     = "arn:aws:iam::584423914806:role/TerraformAdministrativeRole"
    session_name = "terraform-backend"
  }
}
