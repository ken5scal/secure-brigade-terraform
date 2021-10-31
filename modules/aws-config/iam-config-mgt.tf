#resource "aws_iam_service_linked_role" "config_role" {
#  aws_service_name = "config.amazonaws.com"
#}

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

