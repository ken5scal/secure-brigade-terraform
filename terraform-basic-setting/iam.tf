module "terraform-administrator-in-compliance" {
  providers = {
    aws = aws.compliance
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "compliance"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-sandbox" {
  providers = {
    aws = aws.sandbox
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "sandbox"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-logging" {
  providers = {
    aws = aws.logging
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "logging"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-stg" {
  providers = {
    aws = aws.stg
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "stg"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-prod" {
  providers = {
    aws = aws.prod
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "prod"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-shared-resources" {
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "shared-resources"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

module "terraform-administrator-in-security" {
  providers = {
    aws = aws.security
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administration"
  env                      = "security"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

data "aws_iam_policy" "administrator-access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}