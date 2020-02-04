module "root-account-usage-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-1.1-RootAccountUsage"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{$.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\"}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "unauthorized-api-usage-detection" {
  source                    = "./modules/cisAlarms"
  cis-name                  = "AWS-CIS-3.1-UnauthorizedAPIUsage"
  cloudwatch-log-group-name = aws_cloudwatch_log_group.cloudtrail.name
  pattern                   = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"
  //  pattern                    = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")  && ($.userAgent!=\"config.amazonaws.com\") }"
  alarm-threshold            = 5
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

resource "aws_sns_topic" "aws-cis-benchmark" {
  name = "AwsCISBenchmarkAlarm"
}

resource "aws_sns_topic_subscription" "aws-cis-benchmark" {
  topic_arn = aws_sns_topic.aws-cis-benchmark.arn
  protocol  = "https"
  // AWS Chatbot is created manually because terraform is not ready yet
  endpoint               = "https://global.sns-api.chatbot.amazonaws.com"
  endpoint_auto_confirms = true
}