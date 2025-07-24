#!/bin/sh

set -e

sudo sh /vagrant/setup/scripts/k3d_install.sh
sudo sh /vagrant/setup/scripts/k9s_install.sh
sudo sh /vagrant/setup/scripts/k3d_cluster.sh
