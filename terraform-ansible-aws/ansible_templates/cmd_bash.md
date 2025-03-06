
```bash
rm .terraform/terraform.tfstate

aws configure

aws ec2 describe-instances --filters Name=instance-state-name
aws ec2 describe-instances --filters Name=instance-state-name,Values=running

aws s3api create-bucket --bucket terraformstatebucketsy2424
aws s3api list-buckets

terraform init
terraform plan
terraform apply

ansible -a "cat /var/lib/jenkins/secrets/initialAdminPassword" tag_Name_jenkins_master_tf -u ec2-user -b

ssh -i ~/.ssh/id_jdc ec2-user@34.237.138.170


terraform destroy --auto-approve
```