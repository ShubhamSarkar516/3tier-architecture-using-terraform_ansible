#!/bin/bash

set -euo pipefail

echo "🚀 Starting 3-Tier Terraform + Ansible Deployment..."

## Step 1: Run Terraform
echo "📦 Initializing Terraform..."
terraform init

echo "📥 Applying Terraform..."
terraform apply -auto-approve

echo "🕒 Waiting for EC2 instances to boot..."
sleep 30

echo "✅ Terraform provisioning completed."

## Step 2: Show Ansible Inventory
echo "📄 Ansible Inventory:"
cat ./ansible/hosts.ini

## Step 3: Transfer files to Bastion
echo "⏫ Transferring files to Bastion..."

BASTION_IP=$(terraform output -raw bastion_public_ip)
PEM_PATH=~/Threetier_infra/Mafia

scp -o StrictHostKeyChecking=no -i "$PEM_PATH" "$PEM_PATH" ubuntu@$BASTION_IP:.
scp -o StrictHostKeyChecking=no -i "$PEM_PATH" -r ./ansible ubuntu@$BASTION_IP:.
scp -o StrictHostKeyChecking=no -i "$PEM_PATH" -r ./sql ubuntu@$BASTION_IP:./ansible
scp -o StrictHostKeyChecking=no -i "$PEM_PATH" ./forms.html ubuntu@$BASTION_IP:./ansible
scp -o StrictHostKeyChecking=no -i "$PEM_PATH" ./submit.php ubuntu@$BASTION_IP:./ansible

## Step 4: Execute Ansible from Bastion
echo "📡 Running Ansible on Bastion..."

ssh -o StrictHostKeyChecking=no -i "$PEM_PATH" ubuntu@$BASTION_IP << 'EOF'
  set -e
  sudo apt update
  sudo apt install -y ansible
  cd ~/ansible
  chmod 400 ~/Mafia
  ansible-playbook -i hosts.ini web-setup.yml
  ansible-playbook -i hosts.ini app-setup.yml
  source ./db_env.sh
EOF

echo "✅ SUCCESS: All provisioning and configuration complete."
