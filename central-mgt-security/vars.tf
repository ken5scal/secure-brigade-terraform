// Defined in ../global.tfvars
variable "accounts" {}
variable "region" {}
variable "environment" {
  default = "terraform"
}
variable "application" {
  default = "security"
}

variable "initializerRole" {
  default = "CentralMgtSecurityInitializerRole"
}

variable "initializerPolicy" {
  default = "CentralMgtSecurityInitializerPolicy"
}