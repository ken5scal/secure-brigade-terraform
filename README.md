# secure-brigade-terraform
AWS Terraform files used in Secure Brigade

## Manual Configuration
 * MFA Root Accounts
 * Enable accessing IAM User/Role to Billing Info in each account
   * https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/control-access-billing.html
 * AWS SSO settings
 * Terraform Backend S3 & its KMS key

# TODO
## In General
 * [ ] Fix warnings raised by AWS Configs
    * `Ensure hardware MFA is enabled for the 'root' account` is archived because AWS is not yet allowed to register multiple HW keys
 * [ ] Split repository based on the domain (like development lifecycle)
    * ex: centra-mgt-security, service env, compliance...
 * [ ] Makefile

## Initial Configs
 * [x] CloudTrail
 * [x] [GuardDuty](https://github.com/aws-samples/amazon-guardduty-multiaccount-scripts)
 * [x] [Config](https://github.com/awslabs/aws-securityhub-multiaccount-scripts)
    * The above script misses enabling aws config in some aws accounts and region 
 * [x] [SecurityHub](https://github.com/awslabs/aws-securityhub-multiaccount-scripts) 
 * [x] Trusted Advisor
 * [ ] Inspector
 * [ ] Flowlog

## Organization
 * [ ] AWS Health
 * [ ] Other settings (listed in IAM section_ 

## Cloud Trail
 * [ ] Enable CloudTail Insights w/ [PR](https://github.com/terraform-providers/terraform-provider-aws/issues/10988) 
 
## Config
 * [x] Aggregate all ConfigHistory/ConfigSnapshot S3 bucket to shared-resources account (set lifecycle)
 * [ ] Turn on configuration stream (SNS topic)

## Route53
 * [ ] [Simplify DNS management in a multi-account environment with Route 53 Resolver](https://aws.amazon.com/jp/blogs/security/simplify-dns-management-in-a-multiaccount-environment-with-route-53-resolver/)

## S3
 * [x] Centralize or Replicate config-bucket to one place and set lifecycle

## IAM
 * [x] Set Alarm/Log for root account usage (based on CIS Benchmark)
 * [x] Set IAM password Policies
 * [ ] [wHow to use service control policies to set permission guardrails across accounts in your AWS Organization](https://aws.amazon.com/jp/blogs/security/how-to-use-service-control-policies-to-set-permission-guardrails-across-accounts-in-your-aws-organization/)
 * [] Set up iam role so that terraform operation can assume role in cross account environment
 * [] IAM to prohibit EC2 instances only use IMDSv2
 * [] [ABAC Configs using AWS SSO & Session tags](https://aws.amazon.com/jp/blogs/aws/new-for-identity-federation-use-employee-attributes-for-access-control-in-aws/)
 * [] [tag sessions](https://aws.amazon.com/jp/blogs/security/rely-employee-attributes-from-corporate-directory-create-fine-grained-permissions-aws/)
 * [] [tag policies](https://aws.amazon.com/jp/blogs/aws/new-use-tag-policies-to-manage-tags-across-multiple-aws-accounts/)
 * [] rds with iam
 * [] [Netflix's credential compromise detection](https://medium.com/netflix-techblog/netflix-cloud-security-detecting-credential-compromise-in-aws-9493d6fd373a)
 * [] IAM Permission boundary
 * [] alb oidc
 * [] https://aws.amazon.com/jp/blogs/security/iam-share-aws-resources-groups-aws-accounts-aws-organizations/
 * [] [Access Analyze](https://aws.amazon.com/jp/blogs/aws/identify-unintended-resource-access-with-aws-identity-and-access-management-iam-access-analyzer/?sc_channel=sm&sc_campaign=launch_reInvent&sc_publisher=TWITTER&sc_country=Global&sc_outcome=awareness&trkCampaign=CSI_Q4_2019_Storage_S3_re:Invent-S3-Bucket-Protection-Access-Analyzer_&trk=AWS_reInvent_2019_launch__TWITTER&sc_content=AWS_reInvent_2019_launch_&linkId=78103269)
 * [] [S3 Access Points](https://aws.amazon.com/jp/blogs/aws/easily-manage-shared-data-sets-with-amazon-s3-access-points/?sc_channel=sm&sc_campaign=launch_reInvent&sc_publisher=TWITTER&sc_country=re:Invent&sc_outcome=awareness&trk=AWS_reInvent_2019_launch__TWITTER&sc_content=AWS_reInvent_2019_launch_&linkId=78154390)
 * [] [Monitor unused IAM roles with AWS Config](https://t.co/CP2z75ahFK?amp=1)
 
 ## KMS
 * [ ] digital signature
 
 ## CodePiplein
 * [ ] [How to use CI/CD to deploy and configure AWS security services with Terraform
](https://aws.amazon.com/jp/blogs/security/how-use-ci-cd-deploy-configure-aws-security-services-terraform/)
 
 ## API Gateway
 * [ ] [JWT Authorizers](https://dev.classmethod.jp/cloud/aws/amazon-api-gateway-jwt-authorizers/?fbclid=IwAR1fB8FChn5Cc8xkYSkhtAnshwmbfW1yF81nQU8yZUFDEB8u3F2bPZBjDig)
 * [ ] Set up iam role so that terraform operation can assume role in cross account environment
 * [ ] IAM to prohibit EC2 instances only use IMDSv2
 * [ ] [ABAC Configs using AWS SSO & Session tags](https://aws.amazon.com/jp/blogs/aws/new-for-identity-federation-use-employee-attributes-for-access-control-in-aws/)
 * [ ] [tag sessions](https://aws.amazon.com/jp/blogs/security/rely-employee-attributes-from-corporate-directory-create-fine-grained-permissions-aws/)
 * [ ] [tag policies](https://aws.amazon.com/jp/blogs/aws/new-use-tag-policies-to-manage-tags-across-multiple-aws-accounts/)
 * [ ] rds with iam
 * [ ] [Netflix's credential compromise detection](https://medium.com/netflix-techblog/netflix-cloud-security-detecting-credential-compromise-in-aws-9493d6fd373a)
 * [ ] IAM Permission boundary
 * [ ] alb oidc
 * [ ] https://aws.amazon.com/jp/blogs/security/iam-share-aws-resources-groups-aws-accounts-aws-organizations/
 * [ ] [Access Analyze](https://aws.amazon.com/jp/blogs/aws/identify-unintended-resource-access-with-aws-identity-and-access-management-iam-access-analyzer/?sc_channel=sm&sc_campaign=launch_reInvent&sc_publisher=TWITTER&sc_country=Global&sc_outcome=awareness&trkCampaign=CSI_Q4_2019_Storage_S3_re:Invent-S3-Bucket-Protection-Access-Analyzer_&trk=AWS_reInvent_2019_launch__TWITTER&sc_content=AWS_reInvent_2019_launch_&linkId=78103269)
 * [ ] [S3 Access Points](https://aws.amazon.com/jp/blogs/aws/easily-manage-shared-data-sets-with-amazon-s3-access-points/?sc_channel=sm&sc_campaign=launch_reInvent&sc_publisher=TWITTER&sc_country=re:Invent&sc_outcome=awareness&trk=AWS_reInvent_2019_launch__TWITTER&sc_content=AWS_reInvent_2019_launch_&linkId=78154390)
 * [ ] [Monitor unused IAM roles with AWS Config](https://t.co/CP2z75ahFK?amp=1)
 
 ## SSM
 * [ ] Patch Manager
 * [ ] Session Manager
 * [ ] Difference between Secret Manager
 
 ## KMS
 * [ ] digital signature
 
 ## Response 
 * [ ] [diffy](https://medium.com/netflix-techblog/netflix-sirt-releases-diffy-a-differencing-engine-for-digital-forensics-in-the-cloud-37b71abd2698)
  
  ## EC2 
 * [ ] [AWS Backup](https://aws.amazon.com/jp/about-aws/whats-new/2020/01/aws-backup-adds-support-amazon-elastic-cloud-compute-instance-backup/?fbclid=IwAR1ljl7_l5oq5GL_6ZNEVub7fyEZQigdl7UwzYOs9sEwRNOdU08RTK4B0zs)
