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
  retention_in_days = 30

  tags = {
    Name   = "CloudTrailLogs"
    Env    = "master"
    Source = "CloudTrail"
    jobs   = "log-analysis"
  }
}