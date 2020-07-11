resource "aws_iam_role" "apply" {
  name               = "terraform-apply-role"
  assume_role_policy = data.aws_iam_policy_document.sts.json

  tags = {
    env  = var.env
    jobs = var.jobs
  }
}

resource "aws_iam_role_policy_attachment" "apply" {
  role       = aws_iam_role.apply.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "read-only" {
  name               = "terraform-read-only-role"
  assume_role_policy = data.aws_iam_policy_document.sts.json

  tags = {
    env  = var.env
    jobs = var.jobs
  }
}

resource "aws_iam_role_policy_attachment" "read-only" {
  role       = aws_iam_role.read-only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}