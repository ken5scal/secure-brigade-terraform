resource "aws_iam_role" "cloudtrail-servie" {
  name               = "SecureBrigadeCloudTrailServiceRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "cloudtrail-to-cw-log" {
  role   = aws_iam_role.cloudtrail-servie.name
  name   = "SendCloudTrailLogToCloudWatchLogPolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail.name}:log-stream:*"
            ]
        }
    ]
}
POLICY
}

// Role for S3 bucket to replicate objects into other s3 bucket
resource "aws_iam_role" "cloudtrail-replicate-object" {
  provider           = aws.compliance
  name               = "CloudTrailReplicationRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "cloudtrail-replicate-object" {
  provider = aws.compliance
  name     = "CloudTrailReplicationPolicy"
  # Sid 1: Allow original bucket (or s3 as principal) can get replication config and List
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
         "Sid":"1",
         "Effect":"Allow",
         "Action": [
           "s3:GetReplicationConfiguration",
           "s3:ListBucket"
          ],
          "Resource":"${aws_s3_bucket.cloudtrail-replication.arn}"
      }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cloudtrail-replicate-object" {
  provider   = aws.compliance
  role       = aws_iam_role.cloudtrail-replicate-object.name
  policy_arn = aws_iam_policy.cloudtrail-replicate-object.arn
}
