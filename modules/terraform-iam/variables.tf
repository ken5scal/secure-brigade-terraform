variable "env" {
  description = "name of aws account where role is to be assumed."
}
variable "jobs" {
  description = "description of what kind of functionality the role is going to play."
}
variable "aws-account-assumed-from" {
  description = "aws acccount id where the assumption (sts) is conducted"
}