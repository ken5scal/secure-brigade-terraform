variable cis-name {}
variable cloudwatch-log-group-name {}
variable pattern {}
variable sns-topic-alarm-action-arn {}
variable sns-topic-ok-action-arn {}
variable alarm-threshold {
  type    = number
  default = 1
}

resource "aws_cloudwatch_log_metric_filter" "metric-filter" {
  name           = var.cis-name
  log_group_name = var.cloudwatch-log-group-name
  pattern        = var.pattern

  metric_transformation {
    name          = var.cis-name
    namespace     = "AwsCISBenchmark"
    value         = 1
    default_value = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name          = var.cis-name
  namespace           = aws_cloudwatch_log_metric_filter.metric-filter.metric_transformation[0].namespace
  metric_name         = aws_cloudwatch_log_metric_filter.metric-filter.name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.alarm-threshold
  datapoints_to_alarm = 1
  statistic           = "Sum"
  alarm_actions       = [var.sns-topic-alarm-action-arn]
  ok_actions          = [var.sns-topic-ok-action-arn]
}