#!/bin/sh

set -e

sudo sh /vagrant/setup/scripts/k3d_install.sh
sudo sh /vagrant/setup/scripts/k9s_install.sh
sudo sh /vagrant/setup/scripts/k3d_cluster.sh

sudo sh /vagrant/setup/scripts/sshd-x11-setup.sh

kubectl wait --for=condition=Ready nodes --all --timeout=300s
sudo sh /vagrant/srcs/scripts/argocd.sh
