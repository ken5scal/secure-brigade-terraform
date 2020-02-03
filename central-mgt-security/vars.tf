// Defined in ../global.tfvars
variable "accounts" {}
variable "region" {}
variable "environment" {
  default = "terraform"
}
variable "application" {
  default = "central-mgt-security"
}

variable "initializerRole" {
  default = "CentralMgtSecurityInitializerRole"
}

variable "initializerPolicy" {
  default = "CentralMgtSecurityInitializerPolicy"
}