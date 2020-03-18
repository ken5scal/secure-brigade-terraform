data "aws_iam_policy_document" "aws-config-assume-policy" {
  statement {
    effect = "Allow"
    actions = [
    "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
      "config.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "transfer-record" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
    "s3:PutObjectAcl"]
    resources = [
      var.config-recorder-bucket-arn,
    "${var.config-recorder-bucket-arn}/*"]
  }
}

resource "aws_iam_role" "config-mgt" {
  name               = "AWSConfigMgtRole"
  assume_role_policy = data.aws_iam_policy_document.aws-config-assume-policy.json
}

resource "aws_iam_role_policy_attachment" "get-config" {
  role       = aws_iam_role.config-mgt.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy" "transfer-record" {
  name   = "AWSConfigRecordTransferPolicy"
  role   = aws_iam_role.config-mgt.id
  policy = data.aws_iam_policy_document.transfer-record.json
}

variable "config-recorder-bucket-arn" {}
output "iam-arn" {
  value = aws_iam_role.config-mgt.arn
}