#!/bin/bash

set -e

echo "Installing essential tools for Inception of Things..."

echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y \
    curl \
    docker.io \
    docker-compose \
    xorg \
    chromium \
    libnss3-tools \
    vim \
    git

echo "Installing mkcert..."
curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
chmod +x mkcert-v*-linux-amd64
sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/v1.33.3/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/v1.33.3/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl kubectl.sha256

echo "Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "Installing Helm..."
cd /tmp && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 /tmp/get_helm.sh
sudo /tmp/get_helm.sh
rm /tmp/get_helm.sh

echo "Installing K9s..."
sudo apt-get install -y /vagrant/packages/k9s_linux_amd64.deb

echo "Configuring Docker..."
sudo groupadd docker || true
sudo usermod -aG docker vagrant
sudo systemctl restart docker

echo "Configuring SSH X11..."
sudo sed -i 's/#X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config
sudo sed -i 's/#X11DisplayOffset 10/X11DisplayOffset 10/' /etc/ssh/sshd_config
sudo sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

KUBECONFIG_PATH="/etc/rancher/k3d/k3d.yaml"
echo "export KUBECONFIG=\"$KUBECONFIG_PATH\"" >> /root/.bashrc
echo "export KUBECONFIG=\"$KUBECONFIG_PATH\"" >> /home/vagrant/.bashrc
chown vagrant:vagrant /home/vagrant/.bashrc
