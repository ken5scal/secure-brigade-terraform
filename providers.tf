provider "aws" {
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "master")}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "compliance"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "compliance")}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "stg"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "stg")}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "prod"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "prod")}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "security"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "security")}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}