provider "aws" {
  region  = "ap-northeast-1"
  profile = "${lookup(var.accounts, "master")}_AdministratorAccess"
}

provider "aws" {
  alias   = "compliance"
  region  = "ap-northeast-1"
  profile = "${lookup(var.accounts, "compliance")}_AdministratorAccess"
}

provider "aws" {
  alias   = "logging"
  region  = "ap-northeast-1"
  profile = "${lookup(var.accounts, "logging")}_AdministratorAccess"
}