// In security account
resource "aws_iam_role" "initializer" {
  name               = var.initializerRole
  assume_role_policy = data.aws_iam_policy_document.aws-centralized-security-master.json
}

resource "aws_iam_role_policy" "initializer" {
  name     = var.initializerPolicy
  role     = aws_iam_role.initializer.id
  policy   = data.aws_iam_policy_document.initializer.json
}

// in master account
resource "aws_iam_role" "initializer-master" {
  provider = aws.master
  name               = var.initializerRole
  assume_role_policy = data.aws_iam_policy_document.aws-centralized-security-master.json
}

resource "aws_iam_role_policy" "initializer-master" {
  provider = aws.master
  name     = var.initializerPolicy
  role     = aws_iam_role.initializer-master.id
  policy   = data.aws_iam_policy_document.initializer.json
}

// in compliance account
resource "aws_iam_role" "initializer-compliance" {
  provider = aws.compliance
  name               = var.initializerRole
  assume_role_policy = data.aws_iam_policy_document.aws-centralized-security-master.json
}

resource "aws_iam_role_policy" "initializer-compliance" {
  provider = aws.compliance
  name     = var.initializerPolicy
  role     = aws_iam_role.initializer-compliance.id
  policy   = data.aws_iam_policy_document.initializer.json
}

// in stg account
resource "aws_iam_role" "initializer-stg" {
  provider = aws.stg
  name               = var.initializerRole
  assume_role_policy = data.aws_iam_policy_document.aws-centralized-security-master.json
}

resource "aws_iam_role_policy" "initializer-stg" {
  provider = aws.stg
  name     = var.initializerPolicy
  role     = aws_iam_role.initializer-stg.id
  policy   = data.aws_iam_policy_document.initializer.json
}

// in prod account
resource "aws_iam_role" "initializer-prod" {
  provider = aws.prod
  name               = var.initializerRole
  assume_role_policy = data.aws_iam_policy_document.aws-centralized-security-master.json
}

resource "aws_iam_role_policy" "initializer-prod" {
  provider = aws.prod
  name     = var.initializerPolicy
  role     = aws_iam_role.initializer-prod.id
  policy   = data.aws_iam_policy_document.initializer.json
}

// in logging account
resource "aws_iam_role" "initializer-logging" {
  provider = aws.logging
  name               = var.initializerRole
  assume_role_policy = data.aws_iam_policy_document.aws-centralized-security-master.json
}

resource "aws_iam_role_policy" "initializer-logging" {
  provider = aws.logging
  name     = var.initializerPolicy
  role     = aws_iam_role.initializer-logging.id
  policy   = data.aws_iam_policy_document.initializer.json
}

// in shared-resources account
resource "aws_iam_role" "initializer-shared-resources" {
  provider = aws.shared-resources
  name               = var.initializerRole
  assume_role_policy = data.aws_iam_policy_document.aws-centralized-security-master.json
}

resource "aws_iam_role_policy" "initializer-shared-resources" {
  provider = aws.shared-resources
  name     = var.initializerPolicy
  role     = aws_iam_role.initializer-shared-resources.id
  policy   = data.aws_iam_policy_document.initializer.json
}

// in sandbox account
resource "aws_iam_role" "initializer-sandbox" {
  provider = aws.sandbox
  name               = var.initializerRole
  assume_role_policy = data.aws_iam_policy_document.aws-centralized-security-master.json
}

resource "aws_iam_role_policy" "initializer-sandbox" {
  provider = aws.sandbox
  name     = var.initializerPolicy
  role     = aws_iam_role.initializer-sandbox.id
  policy   = data.aws_iam_policy_document.initializer.json
}