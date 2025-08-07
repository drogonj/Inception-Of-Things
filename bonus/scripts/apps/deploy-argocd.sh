#!/bin/bash

set -e

echo "Deploying ArgoCD..."

kubectl create ns argocd || true

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

echo "Configuring ArgoCD for HTTP backend (avoid HTTPS redirect loops)..."
kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge -p='{"data":{"server.insecure":"true"}}'

echo "Restarting ArgoCD server to apply configuration..."
kubectl rollout restart deployment argocd-server -n argocd

echo "Applying ArgoCD ingress configuration..."
kubectl apply -f /vagrant/confs/argocd/ingress.yaml

while ! kubectl get secret argocd-initial-admin-secret -n argocd >/dev/null 2>&1; do
  echo "Waiting for argocd-initial-admin-secret..."
  sleep 2
done

echo "##### ArgoCD Admin Password #####"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | echo $(base64 -d)
echo "#################################"
