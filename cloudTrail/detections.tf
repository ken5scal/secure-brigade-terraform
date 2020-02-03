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

resource "aws_cloudwatch_log_metric_filter" "unauthorized-api-usage-detection" {
  name           = "UnauthorizedAPIUsageDetection"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"

  metric_transformation {
    name          = "UnauthorizedAPIUsageDetection"
    namespace     = "AwsCISBenchmark"
    value         = 1
    default_value = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "root-account-usage-detection" {
  alarm_name          = "AWS-CIS-1.1-RootAccountUsage"
  namespace           = aws_cloudwatch_log_metric_filter.root-account-usage-detection.metric_transformation[0].namespace
  metric_name         = aws_cloudwatch_log_metric_filter.root-account-usage-detection.name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  datapoints_to_alarm = 1
  statistic           = "Sum"
  alarm_actions = [
  aws_sns_topic.root-account-usage-detection.arn]
  ok_actions = [
  aws_sns_topic.root-account-usage-detection.arn]
}

resource "aws_cloudwatch_metric_alarm" "unauthorized-api-usage-detection" {
  alarm_name          = "AWS-CIS-3.1-UnauthorizedAPIUsage"
  namespace           = aws_cloudwatch_log_metric_filter.unauthorized-api-usage-detection.metric_transformation[0].namespace
  metric_name         = aws_cloudwatch_log_metric_filter.unauthorized-api-usage-detection.name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  datapoints_to_alarm = 1
  statistic           = "Sum"
  alarm_actions = [
  aws_sns_topic.root-account-usage-detection.arn]
  ok_actions = [
  aws_sns_topic.root-account-usage-detection.arn]
}

resource "aws_sns_topic" "root-account-usage-detection" {
  name = "rootAccountUsageDetection"
}

resource "aws_sns_topic_subscription" "root-account-usage-detection" {
  topic_arn = aws_sns_topic.root-account-usage-detection.arn
  protocol  = "https"
  // AWS Chatbot is created manually because terraform is not ready yet
  endpoint               = "https://global.sns-api.chatbot.amazonaws.com"
  endpoint_auto_confirms = true
}