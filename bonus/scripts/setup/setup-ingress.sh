#!/bin/bash

set -e

echo "Configuring Ingress and TLS..."

echo "Installing Traefik..."
helm repo add traefik https://traefik.github.io/charts
helm repo update

helm install traefik traefik/traefik \
  --namespace traefik-system \
  --set "ports.websecure.tls.enabled=true" \
  --set "globalArguments={--global.sendanonymoususage=false}" \
  --wait

echo "Waiting for Traefik to be ready..."
kubectl wait --namespace traefik-system \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=traefik \
  --timeout=300s

echo "Generating TLS certificates..."
mkcert 192.168.56.110.nip.io \
       web.192.168.56.110.nip.io \
       gitlab.192.168.56.110.nip.io \
       rancher.192.168.56.110.nip.io \
       argocd.192.168.56.110.nip.io

echo "Installing certs..."
mkcert -install

echo "Creating webapp namespace..."
kubectl create namespace webapp || true

echo "Creating TLS secret..."
kubectl create secret tls iot-cert \
  --cert=192.168.56.110.nip.io+4.pem \
  --key=192.168.56.110.nip.io+4-key.pem \
  -n webapp

echo "Cleaning up temporary files..."
rm -f 192.168.56.110.nip.io+4.pem 192.168.56.110.nip.io+4-key.pem

echo "Traefik and certificates configured successfully!"
