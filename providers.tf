provider "aws" {
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "master")}:role/infra-build-role"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "compliance"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "compliance")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "stg"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "stg")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "prod"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "prod")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "security"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "security")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}