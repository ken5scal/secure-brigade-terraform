resource "aws_securityhub_organization_admin_account" "securityhub" {
  depends_on       = [aws_organizations_organization.org]
  admin_account_id = var.accounts.security
}

resource "aws_securityhub_organization_configuration" "securityhub" {
  provider = aws.security

  depends_on  = [aws_securityhub_organization_admin_account.securityhub]
  auto_enable = true
}

resource "aws_securityhub_organization_admin_account" "securityhub_virginia" {
  provider = aws.master_virginia

  depends_on       = [aws_organizations_organization.org]
  admin_account_id = var.accounts.security
}

resource "aws_securityhub_organization_configuration" "securityhub_virginia" {
  provider = aws.security_virginia

  depends_on  = [aws_securityhub_organization_admin_account.securityhub]
  auto_enable = true
}

// TODO Add aws_securityhub_finding_aggregator
// https://github.com/hashicorp/terraform-provider-aws/pull/21560
