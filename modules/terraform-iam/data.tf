data "aws_iam_policy_document" "sts" {
  statement {
    actions = [
    "sts:AssumeRole"]
    effect = "Allow"
    principals {
      identifiers = [
      "arn:aws:iam::${var.aws-account-assumed-from}:root"]
      type = "AWS"
    }
  }
}