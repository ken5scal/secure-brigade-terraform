resource "aws_iam_role" "cloudtrail" {
  provider = aws.compliance
  name = "CloudTrailReplicationRole"
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

resource "aws_iam_policy" "cloudtrail" {
  provider = aws.compliance
  name = "CloudTrailReplicationPolicy"
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

resource "aws_iam_role_policy_attachment" "cloudtrail" {
  provider = aws.compliance
  role = aws_iam_role.cloudtrail.name
  policy_arn = aws_iam_policy.cloudtrail.arn
}

resource "aws_s3_bucket_policy" "cloudtrail-replication" {
  bucket = aws_s3_bucket.cloudtrail-replication.id
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "S3-Console-Replication-Policy",
    "Statement": [
        {
            "Sid": "S3ReplicationPolicyStmt1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.compliance-account-id}:root"
            },
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:GetBucketVersioning",
                "s3:PutBucketVersioning",
                "s3:ObjectOwnerOverrideToBucketOwner"
            ],
            "Resource": [
                "${aws_s3_bucket.cloudtrail-replication.arn}",
                "${aws_s3_bucket.cloudtrail-replication.arn}/*"
            ]
        }
    ]
}
EOF
}