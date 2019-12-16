// Defined in ../global.tfvars
variable "master-account-id" {}
variable "compliance-account-id" {}
variable "logging-account-id" {}
variable "sandbox-account-id" {}
variable "stg-account-id" {}
variable "prod-account-id" {}
variable "shared-resources-account-id" {}
variable "security-account-id" {}

variable "region" {}
variable "environment" {
  default = "terraform"
}
variable "application" {
  default = "cloudTrail"
}

