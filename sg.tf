// ensure the default sg of every VPC restricts all traffic
resource "aws_security_group" "default-master" {
  name        = "default"
  description = "default VPC security group"
}

resource "aws_security_group" "default-security" {
  provider    = aws.security
  name        = "default"
  description = "default VPC security group"
}

resource "aws_security_group" "default-compliance" {
  provider    = aws.compliance
  name        = "default"
  description = "default VPC security group"
}

resource "aws_security_group" "default-stg" {
  provider    = aws.stg
  name        = "default"
  description = "default VPC security group"
}

resource "aws_security_group" "default-prod" {
  provider    = aws.prod
  name        = "default"
  description = "default VPC security group"
}