#!/bin/bash

set -e

echo "Deploying GitLab..."

echo "Adding the GitLab Helm repository..."
helm repo add gitlab https://charts.gitlab.io/
helm repo update

echo "Creating the gitlab namespace..."
kubectl create namespace gitlab || true

echo "Copying the TLS secret to the gitlab namespace..."
kubectl get secret iot-cert -n webapp -o yaml | \
  sed 's/namespace: webapp/namespace: gitlab/' | \
  kubectl apply -f -

echo "Deploying GitLab (this may take a few minutes)..."
helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  --values /vagrant/confs/gitlab/values.yaml \
  --timeout 20m

echo "Waiting for GitLab to be ready..."
kubectl wait --for=condition=available --timeout=900s deployment/gitlab-webservice-default -n gitlab

echo "Retrieving GitLab root password..."
echo "##### GITLAB ROOT PASSWORD #####"
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath='{.data.password}' | echo $(base64 -d)
echo "################################"
