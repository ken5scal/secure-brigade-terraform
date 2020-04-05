// manually turned on using https://github.com/awslabs/aws-securityhub-multiaccount-scripts
// % python3 enablesecurityhub.py --master_account 085773780922 --assume_role TerraformAdministrativeRole --enabled_regions ap-northeast-1 --enable_standards arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0 hoge.csv
// security hub is not enabled in following region for cost-saving purpose: us-east-2,us-west-1,us-west-2,ap-south-1,ap-northeast-2,ap-southeast-1,ap-southeast-2,ca-central-1,eu-central-1,eu-west-1,eu-west-2,eu-west-3,eu-north-1,sa-east-1
// # cat hoge.csv
//791325445011,kengoscal+aws-master@gmail.com
//491027160565,kengoscal+aws-compliance@gmail.com
//297323088823,kengoscal+aws-stg@gmail.com
//806884417180,kengoscal+aws-prod@gmail.com
//085773780922,kengoscal+aws-security@gmail.com