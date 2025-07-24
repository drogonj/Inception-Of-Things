#!/bin/sh

set -e

##### Installation des dépendances #####
sudo apt-get update
sudo apt-get install -y \
    curl \
    docker.io \
    docker-compose

##### Installation de kubectl #####
echo "Installation de kubectl..."
curl -LO "https://dl.k8s.io/release/v1.33.3/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/v1.33.3/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

##### Installation de k3d #####
echo "Installation de k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d version

##### Docker group setup #####
sudo groupadd docker || true
sudo usermod -aG docker vagrant
sudo systemctl restart docker