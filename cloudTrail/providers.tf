provider "aws" {
  alias   = "master"
  region  = "ap-northeast-1"
  profile = "${var.master-account-id}_AdministratorAccess"
}

provider "aws" {
  alias   = "compliance"
  region  = "ap-northeast-1"
  profile = "${var.compliance-account-id}_AdministratorAccess"
}

provider "aws" {
  alias   = "sandbox"
  region  = "ap-northeast-1"
  profile = "${var.sandbox-account-id}_AdministratorAccess"
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "${var.logging-account-id}_AdministratorAccess"
}

provider "aws" {
  alias   = "stg"
  region  = "ap-northeast-1"
  profile = "${var.stg-account-id}_AdministratorAccess"
}

provider "aws" {
  alias   = "prod"
  region  = "ap-northeast-1"
  profile = "${var.prod-account-id}_AdministratorAccess"
}

provider "aws" {
  alias   = "shared-resources"
  region  = "ap-northeast-1"
  profile = "${var.shared-resources-account-id}_AdministratorAccess"
}

provider "aws" {
  alias   = "security"
  region  = "ap-northeast-1"
  profile = "${var.security-account-id}_AdministratorAccess"
}