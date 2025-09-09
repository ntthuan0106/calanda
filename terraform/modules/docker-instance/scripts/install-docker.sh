#!/bin/bash
set -ex
sudo yum update -y
sudo yum install -y docker
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user