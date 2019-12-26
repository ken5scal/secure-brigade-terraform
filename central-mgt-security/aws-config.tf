// Turned on by following script and manual.
// https://github.com/awslabs/aws-securityhub-multiaccount-scripts

resource "aws_s3_bucket" "config-bucket" {
  provider = aws.shared-resources
  bucket   = "aws-config-bucket-for-secure-brigade"
}

resource "aws_s3_bucket_public_access_block" "config-bucket" {
  provider            = aws.shared-resources
  bucket              = aws_s3_bucket.config-bucket.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_policy" "config-bucket" {
  provider = aws.shared-resources
  bucket   = aws_s3_bucket.config-bucket.id
  policy   = <<POLICY
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
            "Resource": "${aws_s3_bucket.config-bucket.arn}"
        },
        {
            "Sid": " AWSConfigBucketDelivery",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.config-bucket.arn}/AWSLogs/085773780922/Config/*",
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

//module "config" {
//  source = "./aws-config"
//  config-bueckt-name = aws_s3_bucket.config-bucket.bucket
//}