#!/bin/sh

set -e

echo "Installing ArgoCD..."
kubectl create ns argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

echo "Waiting for ArgoCD server service to be available..."
while ! kubectl get svc argocd-server -n argocd >/dev/null 2>&1; do
  echo "Waiting for argocd-server service..."
  sleep 5
done

echo "Starting port-forward..."
nohup kubectl port-forward svc/argocd-server -n argocd 8080:80 > /tmp/argocd-portforward.log 2>&1 &
PORT_FORWARD_PID=$!
echo "Port-forward PID: $PORT_FORWARD_PID"

# Attendre que le port-forward soit réellement actif
echo "Waiting for port-forward to be ready..."
sleep 5
for i in $(seq 1 10); do
  if curl -s http://localhost:8080 >/dev/null 2>&1; then
    echo "Port-forward is ready!"
    break
  fi
  echo "Attempt $i/10: Port-forward not ready yet..."
  sleep 2
done


while ! kubectl get secret argocd-initial-admin-secret -n argocd >/dev/null 2>&1; do
  echo "Waiting for argocd-initial-admin-secret..."
  sleep 2
done

echo "----- argocd base password -----"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | echo $(base64 -d)
echo "--------------------------------"

kubectl apply -f /vagrant/srcs/argocd/
