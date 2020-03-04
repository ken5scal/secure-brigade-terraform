provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_organizations_account" "security" {
  email = "kengoscal+aws-security@gmail.com"
  name  = "secure-brigade-security"
}

resource "aws_organizations_account" "compliance" {
  email = "kengoscal+aws-compliance@gmail.com"
  name  = "secure-brigade-compliance"
}

resource "aws_organizations_account" "shared-resources" {
  email = "kengoscal+aws-shared-resources@gmail.com"
  name  = "secure-brigade-shared-resources"
}

resource "aws_organizations_account" "prod" {
  email = "kengoscal+aws-prod@gmail.com"
  name  = "secure-brigade-prod"
}

resource "aws_organizations_account" "stg" {
  email = "kengoscal+aws-stg@gmail.com"
  name  = "secure-brigade-stg"
}
