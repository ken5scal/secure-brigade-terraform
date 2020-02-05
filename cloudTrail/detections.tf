module "root-account-usage-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-1.1-RootAccountUsage"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{$.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\"}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "unauthorized-api-usage-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.1-UnauthorizedAPIUsage"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"
  alarm-threshold            = 5
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "consle-signin-without-mfa-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.2-ConsoleSignInWithoutMFA"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=\"ConsoleLogin\") && ($.additionalEventData.MFAUsed !=\"Yes\") && ($.additionalEventData.SamlProviderArn NOT EXISTS)}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "iam-policy-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.4-IAMPolicyChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=DeleteGroupPolicy) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeletePolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.eventName=AttachGroupPolicy) || ($.eventName=DetachGroupPolicy)}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "cloudtrail-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.5-CloudTrailChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "console-authentication-failure-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.6-ConsoleAuthenticationFailure"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=ConsoleLogin) && ($.errorMessage=\"Failed authentication\")}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "disable-or-delete-cmk-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.7-DisableOrDeleteCMK"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "s3-bucket-policy-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.8-S3BucketPolicyChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "aws-config-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.9-AWSConfigChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventSource=config.amazonaws.com) && (($.eventName=StopConfigurationRecorder) || ($.eventName=DeleteDeliveryChannel) || ($.eventName=PutDeliveryChannel) || ($.eventName=PutConfigurationRecorder))}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "security-group-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.10-SecurityGroupChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=AuthorizeSecurityGroupIngress) || ($.eventName=AuthorizeSecurityGroupEgress) || ($.eventName=RevokeSecurityGroupIngress) || ($.eventName=RevokeSecurityGroupEgress) || ($.eventName=CreateSecurityGroup) || ($.eventName=DeleteSecurityGroup)}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "nacl-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.11-NetworkACLChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=CreateNetworkAcl) || ($.eventName=CreateNetworkAclEntry) || ($.eventName=DeleteNetworkAcl) || ($.eventName=DeleteNetworkAclEntry) || ($.eventName=ReplaceNetworkAclEntry) || ($.eventName=ReplaceNetworkAclAssociation)}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "network-gateway-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.12-NetworkGatewayChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=CreateCustomerGateway) || ($.eventName=DeleteCustomerGateway) || ($.eventName=AttachInternetGateway) || ($.eventName=CreateInternetGateway) || ($.eventName=DeleteInternetGateway) || ($.eventName=DetachInternetGateway)}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "route-table-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.13-RouteTableChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable)}"
  sns-topic-alarm-action-arn = aws_sns_topic.aws-cis-benchmark.arn
  sns-topic-ok-action-arn    = aws_sns_topic.aws-cis-benchmark.arn
}

module "vpc-changes-detection" {
  source                     = "./modules/cisAlarms"
  cis-name                   = "AWS-CIS-3.14-VPCChanges"
  cloudwatch-log-group-name  = aws_cloudwatch_log_group.cloudtrail.name
  pattern                    = "{($.eventName=CreateVpc) || ($.eventName=DeleteVpc) || ($.eventName=ModifyVpcAttribute) || ($.eventName=AcceptVpcPeeringConnection) || ($.eventName=CreateVpcPeeringConnection) || ($.eventName=DeleteVpcPeeringConnection) || ($.eventName=RejectVpcPeeringConnection) || ($.eventName=AttachClassicLinkVpc) || ($.eventName=DetachClassicLinkVpc) || ($.eventName=DisableVpcClassicLink) || ($.eventName=EnableVpcClassicLink)}"
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