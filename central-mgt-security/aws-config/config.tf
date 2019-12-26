resource "aws_config_configuration_recorder" "recorder" {
  name = "default"
  role_arn = data.aws_iam_role.service-role.arn
}

resource "aws_config_delivery_channel" "channel" {
  name = "default"
  s3_bucket_name = var.config-bueckt-name
  depends_on = [
    aws_config_configuration_recorder.recorder]
}

resource "aws_config_configuration_recorder_status" "recorder" {
  name = "default"
  is_enabled = true
  depends_on = [
    aws_config_delivery_channel.channel]
}