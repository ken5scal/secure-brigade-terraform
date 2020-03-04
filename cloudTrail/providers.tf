provider "aws" {
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