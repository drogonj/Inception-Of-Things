#!/bin/sh

set -e

KUBECONFIG_PATH="/etc/rancher/k3d/k3d.yaml"

###### Installation de K9s #####
sudo apt-get install -y /vagrant/setup/packages/k9s_linux_amd64.deb
export KUBECONFIG="$KUBECONFIG_PATH"
echo "export KUBECONFIG=\"$KUBECONFIG_PATH\"" >> /root/.bashrc
echo "export KUBECONFIG=\"$KUBECONFIG_PATH\"" >> /home/vagrant/.bashrc
chown vagrant:vagrant /home/vagrant/.bashrc

##### Vérification post-install #####
k9s version

echo "Installation de K9s terminée avec succès!"