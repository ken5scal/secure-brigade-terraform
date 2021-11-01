#resource "aws_securityhub_product_subscription" "guardduty" {
#  depends_on  = [aws_securityhub_account.org]
#  product_arn = "arn:aws:securityhub:${var.region}::product/aws/guardduty"
#}

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
