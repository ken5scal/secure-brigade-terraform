resource "aws_organizations_policy" "deny-deleting-security-and-audit-settings" {
  name        = "DenyDeletingSecurityAndAuditSettings"
  description = "Deny Removing/Deleting/Disabling AWS Security And Audit Settings"
  content     = <<CONTENT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyDeletingSecurityAndAuditSettings",
            "Effect": "Deny",
            "Action": [
                "guardduty:Delete*",
                "guardduty:DisassociateFromMasterAccount",
                "guardduty:UntagResource",
                "guardduty:DeclineInvitations",
                "guardduty:DisassociateMembers",
                "cloudtrail:DeleteTrail",
                "cloudtrail:RemoveTags",
                "cloudtrail:StopLogging",
                "securityhub:DeclineInvitations",
                "securityhub:Delete*",
                "securityhub:Disassociate*",
                "securityhub:Disable*",
                "securityhub:UntagResource",
                "config:Delete*",
                "config:StopConfigurationRecorder"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
CONTENT
}

resource "aws_organizations_policy_attachment" "root" {
  policy_id = aws_organizations_policy.deny-deleting-security-and-audit-settings.id
  target_id = aws_organizations_organization.org.roots.0.id
}