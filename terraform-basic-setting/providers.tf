provider "aws" {
  region  = var.region
  profile = "${lookup(var.accounts, "shared-resources")}_AdministratorAccess"
}

provider "aws" {
  alias   = "logging"
  region  = var.region
  profile = "${lookup(var.accounts, "logging")}_AdministratorAccess"
}