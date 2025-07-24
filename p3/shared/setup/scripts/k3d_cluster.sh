#!/bin/sh

set -e

##### Création du cluster K3d #####
echo "Création du cluster K3d..."
k3d cluster create iot
kubectl cluster-info

##### Partage du contexte kube #####
echo "Partage du contexte kube..."
sudo k3d kubeconfig write iot --output /etc/rancher/k3d/k3d.yaml
sudo chmod 644 /etc/rancher/k3d/k3d.yaml
