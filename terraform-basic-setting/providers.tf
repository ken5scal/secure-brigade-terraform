provider "aws" {
  alias   = "master"
  region  = var.region
  profile = "${lookup(var.accounts, "master")}_AdministratorAccess"
}

provider "aws" {
  alias   = "compliance"
  region  = var.region
  profile = "${lookup(var.accounts, "compliance")}_AdministratorAccess"
}

provider "aws" {
  alias   = "sandbox"
  region  = var.region
  profile = "${lookup(var.accounts, "sandbox")}_AdministratorAccess"
}

provider "aws" {
  alias   = "logging"
  region  = var.region
  profile = "${lookup(var.accounts, "logging")}_AdministratorAccess"
}

provider "aws" {
  alias   = "stg"
  region  = var.region
  profile = "${lookup(var.accounts, "stg")}_AdministratorAccess"
}

provider "aws" {
  alias   = "prod"
  region  = var.region
  profile = "${lookup(var.accounts, "prod")}_AdministratorAccess"
}

provider "aws" {
  region  = var.region
  profile = "${lookup(var.accounts, "shared-resources")}_AdministratorAccess"
}

provider "aws" {
  alias   = "security"
  region  = var.region
  profile = "${lookup(var.accounts, "security")}_AdministratorAccess"
}