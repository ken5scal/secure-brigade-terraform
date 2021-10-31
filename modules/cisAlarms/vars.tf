variable cis-name {}
variable cloudwatch-log-group-name {}
variable pattern {}
variable sns-topic-alarm-action-arn {}
variable sns-topic-ok-action-arn {}
variable alarm-threshold {
  type    = number
  default = 1
}