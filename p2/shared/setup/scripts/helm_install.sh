#!/bin/sh

set -e

###### Installation de Helm #####
cd /tmp && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 /tmp/get_helm.sh
sudo /tmp/get_helm.sh

##### Verification post-install #####
helm version
