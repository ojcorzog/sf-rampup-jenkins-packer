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
echo "SYNTAX = ./apply.sh <PATH>"
echo "EXAMPLE = ./apply.sh terraform/instance"
echo ""
exit
fi
######################################################################################
terraform get $1
terraform apply -auto-approve $1 
######################################################################################
