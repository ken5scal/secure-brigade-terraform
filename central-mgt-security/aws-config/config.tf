resource "aws_config_configuration_recorder" "this" {
  name     = "this"
  role_arn = data.aws_iam_role.service-role.arn
}

resource "aws_config_delivery_channel" "this" {
  name = "channel"
  s3_bucket_name = var.config-bueckt-name
  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name = aws
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}

