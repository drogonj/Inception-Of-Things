#!/bin/sh

set -e

# Namespaces
kubectl apply -f /vagrant/srcs/namespaces/inception-of-things.yaml

# Deployments
kubectl apply -f /vagrant/srcs/apps/app1.yaml
kubectl apply -f /vagrant/srcs/apps/app2.yaml
kubectl apply -f /vagrant/srcs/apps/app3.yaml

# Ingresses
kubectl apply -f /vagrant/srcs/ingress/iot-ingress.yaml

echo "Deployment scripts executed successfully!"