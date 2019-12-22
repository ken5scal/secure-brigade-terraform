// Defined in ../global.tfvars
variable "accounts" {}
variable "region" {}
variable "environment" {
  default = "terraform"
}
variable "application" {
  default = "cloudTrail"
}

