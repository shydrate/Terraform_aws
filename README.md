# Terraform_aws
This repo deals with creating a ec2instance,elastic ip, subnet, vpc using terraform

#Steps to run terraform:
1. Install terraform.
2. Clone repo in your system.
3. Open provider.tf, add your Access_key and Secret_key.
4. Initialize terraform in the cloned directory `terraform init`
5. Use plan command to see values that are set `terraform plan`
6. Now create instance by running `terraform apply` it will ask for approve, type yes. You can bypass it by using `terraform apply --auto-approve`.
7. Verify all the instance are ceated.
8. Now to destroy the instance run `terraform destroy --auto-approve`

Screenshots
![alt text](https://github.com/shydrate/Terraform_aws/blob/master/Screenshots/Instance.png)
