resource "aws_iam_role" "terraform-role" {
  name               = var.role-name
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": ["arn:aws:iam::${var.aws-account-assumed-from}:root"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  tags = {
    name = var.role-name
    env  = var.env
    jobs = var.jobs
  }
}

resource "aws_iam_role_policy" "terraform-role" {
  role   = aws_iam_role.terraform-role.id
  policy = <<EOF
${var.iam-policy-document}
EOF
}