resource "aws_config_configuration_aggregator" "config_aggregator" {
  depends_on = [aws_iam_role_policy_attachment.org-aggregator]

  name = "secure-brigade-config-aggregator"

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.org-aggregator.arn
  }
}