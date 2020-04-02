#######################################################################################
#!/bin/bash
######################################################################################
# Author        : DevOps
# Email         : ojcorzog@gmail.com
# Description   : Terraform apply script
######################################################################################
# Export Path Variable
export PATH=$PATH:/opt
######################################################################################
# If statement to ensure a user has provided a Terraform folder path
if [[ -z "$1" ]]; then
echo ""
echo "You have not provided a Terraform path."
echo "SYNTAX = ./destroy.sh <PATH>"
echo "EXAMPLE = ./destroy.sh terraform/instance"
echo ""
exit
fi
######################################################################################
terraform init $1
terraform get $1
terraform destroy -auto-approve $1 
######################################################################################
