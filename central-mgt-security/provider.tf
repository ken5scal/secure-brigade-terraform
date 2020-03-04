provider "aws" {
  alias  = "master"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "compliance"
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "compliance")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "stg"
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "stg")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "prod"
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "prod")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "shared-resources"
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "shared-resources")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "security")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}