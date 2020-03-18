# terraform-iam module
generate aws iam roles for terraform operations

# Getting Started

```
module "terraform-administrator" {
  providers = {
    aws = aws.logging
  }
  source                   = "./modules/terraform-iam"
  role-name                = "TerraformAdministrativeRole"
  jobs                     = "administrating"
  env                      = "logging"
  aws-account-assumed-from = lookup(var.accounts, "master")
  iam-policy-document      = data.aws_iam_policy.administrator-access.policy
}

data "aws_iam_policy" "administrator-access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
```

# Input/Output
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws-account-assumed-from | n/a | `string` | `"aws acccount id where the assumption (sts) is conducted"` | no |
| env | name of aws account where role is to be assumed. | `any` | n/a | yes |
| iam-policy-document | n/a | `string` | `"iam policy document for the role"` | no |
| jobs | description of what kind of functionality the role is going to play. | `any` | n/a | yes |
| role-name | name of the aws iam role that is to be assumed | `any` | n/a | yes |

## Outputs

No output.
