#!/bin/sh

set -e

sudo sh /vagrant/setup/scripts/k3s_install.sh
sudo sh /vagrant/setup/scripts/k9s_install.sh
sudo sh /vagrant/setup/scripts/helm_install.sh

sh /vagrant/srcs/scripts/deploy.sh
