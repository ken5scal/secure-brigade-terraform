provider "aws" {
  region  = var.region
  profile = "${var.shared-resources-account-id}_AdministratorAccess"
}

provider "aws" {
  alias   = "logging"
  region  = var.region
  profile = "${var.logging-account-id}_AdministratorAccess"
}