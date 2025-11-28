#!/bin/bash
# Basic bootstrap for the control node to install Ansible and common tools
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y software-properties-common apt-transport-https ca-certificates curl git python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install ansible boto3 botocore

# Ensure ubuntu user has an .ssh directory
su - ubuntu -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh"

echo "Bootstrap completed" > /var/log/user-data.done
