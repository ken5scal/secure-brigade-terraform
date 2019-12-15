// Defined in ../global.tfvars
variable "shared-resources-account-id" {}
variable "logging-account-id" {}
variable "region" {}
variable "environment" {
  default = "terraform"
}
variable "application" {
  default = "terraform-basic-setting"
}

