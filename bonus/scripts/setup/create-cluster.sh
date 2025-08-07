#!/bin/bash

set -e

echo "Creating K3D cluster."

echo "Cleaning up existing clusters..."
k3d cluster delete inception-of-things 2>/dev/null || true

echo "Creating inception-of-things cluster..."
k3d cluster create inception-of-things \
  --api-port 6550 \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer" \
  --k3s-arg "--disable=traefik@server:0"

echo "Cluster created successfully."
kubectl cluster-info

echo "Configuring kubecontext."
sudo k3d kubeconfig write inception-of-things --output /etc/rancher/k3d/k3d.yaml
sudo chmod 644 /etc/rancher/k3d/k3d.yaml

echo "Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo "Creating necessary namespaces..."
kubectl create namespace cattle-system || true
kubectl create namespace traefik-system || true
kubectl create namespace gitlab || true
kubectl create namespace dev || true
kubectl create namespace argocd || true

echo "Cluster setup complete."
