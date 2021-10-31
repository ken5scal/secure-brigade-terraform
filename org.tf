resource "aws_organizations_organization" "org" {
  // TODO AWSはOrganizationの設定から下記のサービスを有効化することを推奨していない
  // Instead, use the other AWS service’s console to enable and disable trusted access with AWS Organizations. This allows the other service to perform any supporting tasks needed to enable or disable access with Organizations.
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "sso.amazonaws.com",
    "ssm.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
    "access-analyzer.amazonaws.com",
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "aws-artifact-account-sync.amazonaws.com",
    "fms.amazonaws.com",
    "macie.amazonaws.com",
    "backup.amazonaws.com",
    "license-manager.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "account.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "ds.amazonaws.com",
    "license-management.marketplace.amazonaws.com",
    "ram.amazonaws.com",
    "storage-lens.s3.amazonaws.com"
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
    "BACKUP_POLICY",
    //"AISERVICES_OPT_OUT_POLICY"
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
