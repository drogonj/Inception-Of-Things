#!/bin/bash

set -e

echo "=== Inception Of Things ==="

SCRIPT_DIR="/vagrant/scripts"

sudo bash "$SCRIPT_DIR/setup/install-tools.sh"

bash "$SCRIPT_DIR/setup/create-cluster.sh"

bash "$SCRIPT_DIR/setup/setup-ingress.sh"

bash "$SCRIPT_DIR/apps/deploy-rancher.sh"

bash "$SCRIPT_DIR/apps/deploy-gitlab.sh"

bash "$SCRIPT_DIR/apps/deploy-argocd.sh"

echo "=== ServicesDeployed ==="
echo "You can now generate a new ACCESS_TOKEN via gitlab and use /vagrant/scripts/apps/webapp-cd.sh to create the webapp repository. And ArgoCD will automatically deploy it to the dev namespace."
