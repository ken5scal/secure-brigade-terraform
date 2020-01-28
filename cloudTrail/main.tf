resource "aws_cloudtrail" "master" {
  name                       = "cloudtrail-master"
  s3_bucket_name             = aws_s3_bucket.cloudtrail.id
  is_multi_region_trail      = true
  is_organization_trail      = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail-servie.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = [
      "arn:aws:s3:::"]
    }
  }
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  // Cloud Watch Log must be in the same account as sending CloudTrail
  name              = "CloudTrailLogs"
  retention_in_days = 7

  tags = {
    Name   = "CloudTrailLogs"
    Env    = "master"
    Source = "CloudTrail"
    jobs   = "log-analysis"
  }
}

resource "aws_cloudwatch_log_metric_filter" "root-account-usage-detection" {
  name           = "RootAccountUsageCount"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{$.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\"}"

  metric_transformation {
    name          = "RootAccountUsageCount"
    namespace     = "AwsCISBenchmark"
    value         = 1
    default_value = 0
  }
}

resource "aws_sns_topic" "root-account-usage-detection" {
  name = "rootAccountUsageDetection"
}

resource "aws_sns_topic_subscription" "root-account-usage-detection" {
  topic_arn = aws_sns_topic.root-account-usage-detection.arn
  protocol  = "https"
  // AWS Chatbot is created manually because terraform is not ready yet
  endpoint = "https://global.sns-api.chatbot.amazonaws.com"
}

resource "aws_cloudwatch_metric_alarm" "root-account-usage-detection" {
  alarm_name          = "AWS-CIS-1.1-RootAccountUsage"
  namespace           = aws_cloudwatch_log_metric_filter.root-account-usage-detection.metric_transformation[0].namespace
  metric_name         = aws_cloudwatch_log_metric_filter.root-account-usage-detection.name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  statistic           = "Sum"
  alarm_actions = [
  aws_sns_topic.root-account-usage-detection.arn]
  ok_actions = [
  aws_sns_topic.root-account-usage-detection.arn]
}