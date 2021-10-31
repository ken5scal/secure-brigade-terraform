#
#resource "aws_organizations_organization" "example" {
#  aws_service_access_principals = ["securityhub.amazonaws.com"]
#  feature_set                   = "ALL"
#}
#
#resource "aws_securityhub_organization_admin_account" "securityhub" {
#  depends_on = [aws_organizations_organization.example]
#  admin_account_id = var.accounts.security
#}
#
#resource "aws_securityhub_organization_configuration" "example" {
#  depends_on = [aws_securityhub_organization_admin_account.securityhub]
#  auto_enable = true
#}
#
#resource "aws_securityhub_product_subscription" "guardduty" {
#  depends_on  = [aws_securityhub_account.example]
#  product_arn = "arn:aws:securityhub:${var.region}::product/aws/guardduty"
#}
#
#resource "aws_securityhub_product_subscription" "inspector" {
#  depends_on  = [aws_securityhub_account.example]
#  product_arn = "arn:aws:securityhub:${var.region}::product/aws/inspector"
#}
#
#resource "aws_securityhub_product_subscription" "macie" {
#  depends_on  = [aws_securityhub_account.example]
#  product_arn = "arn:aws:securityhub:${var.region}::product/aws/macie"
#}
#
#resource "aws_securityhub_standards_subscription" "securityhub" {
#  provider   = aws.security
#  depends_on = [aws_securityhub_account.securityhub]
#
#  standards_arn = "arn:aws:securityhub:ap-northaws_securityhub_product_subscriptioneast-1::standards/aws-foundational-security-best-practices/v/1.0.0"
#}
##
##resource "aws_securityhub_standards_subscription" "securityhub_virginia" {
##  provider   = aws.security-virginia
##  depends_on = [aws_securityhub_account.securityhub_virginia]
##
##  standards_arn = "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"
##}