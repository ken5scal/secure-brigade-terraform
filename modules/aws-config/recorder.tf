resource "aws_config_configuration_recorder" "recorder" {
  name     = var.config_recorder_name
  role_arn = aws_iam_role.config-mgt.arn // aws_iam_service_linked_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "recorder" {
  depends_on = [aws_config_delivery_channel.recorder]

  name       = aws_config_configuration_recorder.recorder.name
  is_enabled = true
}

resource "aws_config_delivery_channel" "recorder" {
  depends_on = [aws_config_configuration_recorder.recorder]

  // 手動で設定したため、名前がdefaultになっている
  // 変更すると再作成になるが、configのrecordingを停止しなければいけないのでこのまま
  name           = aws_config_configuration_recorder.recorder.name
  s3_bucket_name = var.config_recorder_bucket_name

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}