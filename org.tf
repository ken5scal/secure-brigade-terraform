resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com",
    "ssm.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
    "access-analyzer.amazonaws.com",
    "guardduty.amazonaws.com",
    "aws-artifact-account-sync.amazonaws.com",
    "fms.amazonaws.com"
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY"
  ]

  feature_set = "ALL"
}

resource "aws_organizations_account" "security" {
  email = "kengoscal+aws-security@gmail.com"
  name  = "secure-brigade-security"
}

resource "aws_organizations_account" "compliance" {
  email = "kengoscal+aws-compliance@gmail.com"
  name  = "secure-brigade-compliance"
}

resource "aws_organizations_account" "prod" {
  email = "kengoscal+aws-prod@gmail.com"
  name  = "secure-brigade-prod"
}

resource "aws_organizations_account" "stg" {
  email = "kengoscal+aws-stg@gmail.com"
  name  = "secure-brigade-stg"
}
