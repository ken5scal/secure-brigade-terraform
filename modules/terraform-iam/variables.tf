variable "env" {
  description = "name of aws account where role is to be assumed."
}
variable "jobs" {
  description = "description of what kind of functionality the role is going to play."
}
variable "role-name" {
  description = "name of the aws iam role that is to be assumed"
}
variable "iam-policy-document" {
  default = "iam policy document for the role"
}
variable "aws-account-assumed-from" {
  default = "aws acccount id where the assumption (sts) is conducted"
}
