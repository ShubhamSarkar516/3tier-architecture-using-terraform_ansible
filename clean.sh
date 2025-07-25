terraform destroy --auto-approve
rm terraform.tfstate
rm terraform.tfstate.backup
rm ansible/hosts.ini
touch ansible/hosts.ini
echo "Done"
