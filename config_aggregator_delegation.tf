resource "null_resource" "config_delegated" {
  provisioner "local-exec" {
    command    = "aws organizations register-delegated-administrator --account-id ${aws_organizations_account.security.id} --service-principal config.amazonaws.com"
    on_failure = fail
  }
}

resource "null_resource" "config_multi_setup_delegated" {
  provisioner "local-exec" {
    command    = "aws organizations register-delegated-administrator --account-id ${aws_organizations_account.security.id} --service-principal config-multiaccountsetup.amazonaws.com"
    on_failure = fail
  }
  depends_on = [null_resource.config_delegated]
}