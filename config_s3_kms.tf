resource "aws_kms_key" "config-bucket" {
  provider            = aws.compliance
  description         = "key to encrypt/decrypt s3 storing AWS Configs"
  enable_key_rotation = true
}

resource "aws_kms_alias" "config-bucket" {
  provider      = aws.compliance
  name          = "alias/config-bucket-key"
  target_key_id = aws_kms_key.config-bucket.key_id
}