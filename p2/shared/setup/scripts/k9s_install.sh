#!/bin/sh

set -e

###### Installation de K9s #####
sudo apt install -y /vagrant/setup/packages/k9s_linux_amd64.deb
export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
echo "export KUBECONFIG=\"/etc/rancher/k3s/k3s.yaml\"" >> ~/.bashrc
echo "export KUBECONFIG=\"/etc/rancher/k3s/k3s.yaml\"" >> /home/vagrant/.bashrc
chown vagrant:vagrant /home/vagrant/.bashrc

##### Vérification post-install #####
k9s version

echo "Installation de K9s terminée avec succès!"