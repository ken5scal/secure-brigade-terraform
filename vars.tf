variable "TerraformAssumeRoleName" {
  default = "terraform-apply-role"
}
variable "accounts" {
  default = {
    master     = "791325445011"
    compliance = "491027160565"
    stg        = "297323088823"
    prod       = "806884417180"
    security   = "085773780922"
  }
}
variable "environment" {
  default = "terraform"
}
variable "application" {
  default = "terraform-basic-setting"
}

