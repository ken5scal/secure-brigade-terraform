// Turned on by following script and manual.
// https://github.com/awslabs/aws-securityhub-multiaccount-scripts

resource "aws_s3_bucket" "config-bucket" {
  //  alias = provier.shared-resources
  bucket = "config-bucekt-085773780922"

}

resource "aws_s3_bucket_policy" "config-bucket" {
  bucket = aws_s3_bucket.config-bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSConfigBucketPermissionsCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::config-bucket-085773780922"
        },
        {
            "Sid": " AWSConfigBucketDelivery",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::config-bucket-085773780922/AWSLogs/085773780922/Config/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

module "config" {
  source = "aws-config"
  config-bueckt-name = aws_s3_bucket.config-bucket.bucket
}