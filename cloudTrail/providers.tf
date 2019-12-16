provider "aws" {
  region  = "ap-northeast-1"
  profile = "${var.logging-account-id}_AdministratorAccess"
}