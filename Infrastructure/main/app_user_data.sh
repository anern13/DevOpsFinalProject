#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y git docker.io
systemctl enable docker
systemctl start docker

# Clone the MidtermProj repo (keeps original frontend/backend unchanged)
cd /home/ubuntu
if [ ! -d MidtermProj ]; then
  git clone https://github.com/anern13/MidtermProj.git
else
  cd MidtermProj && git pull --rebase || true
fi

cd /home/ubuntu/MidtermProj

# Build Docker image using repo Dockerfile
docker build -t leads-manager-app:latest .

# Run container on port 80 -> app port 5000
if docker ps -a --format '{{.Names}}' | grep -q '^leads-manager-app$'; then
  docker rm -f leads-manager-app
fi
docker run -d --name leads-manager-app --restart unless-stopped -p 5000:5000 leads-manager-app:latest

# Basic health check
sleep 3
curl -fsS http://localhost:5000/ || true
