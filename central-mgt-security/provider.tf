provider "aws" {
  alias = "master"
  region = "ap-northeast-1"
  profile = "${lookup(var.accounts, "master")}_AdministratorAccess"
}

provider "aws" {
  alias = "compliance"
  region = "ap-northeast-1"
  profile = "${lookup(var.accounts, "compliance")}_AdministratorAccess"
}

provider "aws" {
  alias = "sandbox"
  region = "ap-northeast-1"
  profile = "${lookup(var.accounts, "sandbox")}_AdministratorAccess"
}

provider "aws" {
  alias = "logging"
  region = "ap-northeast-1"
  profile = "${lookup(var.accounts, "logging")}_AdministratorAccess"
}

provider "aws" {
  alias = "stg"
  region = "ap-northeast-1"
  profile = "${lookup(var.accounts, "stg")}_AdministratorAccess"
}

provider "aws" {
  alias = "prod"
  region = "ap-northeast-1"
  profile = "${lookup(var.accounts, "prod")}_AdministratorAccess"
}

provider "aws" {
  alias = "shared-resources"
  region = "ap-northeast-1"
  profile = "${lookup(var.accounts, "shared-resources")}_AdministratorAccess"
}

provider "aws" {
  region = "ap-northeast-1"
  profile = "${lookup(var.accounts, "security")}_AdministratorAccess"
}