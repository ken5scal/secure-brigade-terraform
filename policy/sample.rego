package main

deny[msg] {
  resource := input.resource_changes[index]
  resource.type == "aws_cloudtrail"
  resource.change.after.cloud_watch_logs_group_arn != "arn:aws:logs:ap-northeast-1:791325445011:log-group:CloudTrailLogs:*"
  hoge := resource.change.after
  not hoge.cloud_watch_logs_group_arn
  msg = "cloud trail must output cloud watch logs"
}
