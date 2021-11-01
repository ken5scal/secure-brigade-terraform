provider "aws" {
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${var.accounts.master}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "master_virginia"
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::${var.accounts.master}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "compliance"
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${var.accounts.compliance}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "stg"
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${var.accounts.stg}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "prod"
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${var.accounts.prod}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "security"
  region = "ap-northeast-1"

  assume_role {
    role_arn     = "arn:aws:iam::${var.accounts.security}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}

provider "aws" {
  alias  = "security_virginia"
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::${var.accounts.security}:role/${var.TerraformAssumeRoleName}"
    session_name = "terraform-operation"
  }
}