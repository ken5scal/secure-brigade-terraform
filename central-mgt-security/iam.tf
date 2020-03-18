module "password-policy-security" {
  source = "./modules/iam-user-password-policy"
}

module "password-policy-master" {
  providers = {
    aws = aws.master
  }
  source = "./modules/iam-user-password-policy"
}

module "password-policy-compliance" {
  providers = {
    aws = aws.compliance
  }
  source = "./modules/iam-user-password-policy"
}

module "password-policy-stg" {
  providers = {
    aws = aws.stg
  }
  source = "./modules/iam-user-password-policy"
}

module "password-policy-prod" {
  providers = {
    aws = aws.prod
  }
  source = "./modules/iam-user-password-policy"
}