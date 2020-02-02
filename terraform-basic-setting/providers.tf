provider "aws" {
  alias  = "master"
  region = var.region
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
  alias  = "sandbox"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "sandbox")}:role/TerraformAdministrativeRole"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "logging"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "logging")}:role/TerraformAdministrativeRole"
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
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${lookup(var.accounts, "shared-resources")}:role/TerraformAdministrativeRole"
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