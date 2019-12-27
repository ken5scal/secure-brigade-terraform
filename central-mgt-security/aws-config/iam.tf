data "aws_iam_role" "service-role" {
  name = "AWSServiceRoleForConfig"
}

resource "aws_iam_role" "upload-aws-config" {
  role               = ""
  assume_role_policy = ""
  policy             = ""
}