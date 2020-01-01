module "password-policy-security" {
  //  providers = {
  //    aws = aws.security
  //  }
  source = "./modules/aws-iam"
}

module "password-policy-master" {
  providers = {
    aws = aws.master
  }
  source = "./modules/aws-iam"
}

module "password-policy-compliance" {
  providers = {
    aws = aws.compliance
  }
  source = "./modules/aws-iam"
}

module "password-policy-sandbox" {
  providers = {
    aws = aws.sandbox
  }
  source = "./modules/aws-iam"
}

module "password-policy-logging" {
  providers = {
    aws = aws.logging
  }
  source = "./modules/aws-iam"
}

module "password-policy-stg" {
  providers = {
    aws = aws.stg
  }
  source = "./modules/aws-iam"
}

module "password-policy-prod" {
  providers = {
    aws = aws.prod
  }
  source = "./modules/aws-iam"
}

module "password-policy-shared-resources" {
  providers = {
    aws = aws.shared-resources
  }
  source = "./modules/aws-iam"
}