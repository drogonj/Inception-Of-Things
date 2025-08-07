#!/bin/bash

set -e

echo "Deploying Rancher..."
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    -f /vagrant/confs/rancher/values.yaml

while ! kubectl get pods -n cattle-system | grep rancher | grep -q Running
do
    echo "Waiting for Rancher to be ready..."
    sleep 5
done

while ! kubectl get secret --namespace cattle-system bootstrap-secret >/dev/null 2>&1
do
    echo "Waiting for Rancher bootstrap secret..."
    sleep 5
done

echo "##### RANCHER PASSWORD #####"
kubectl get secret --namespace cattle-system bootstrap-secret \
    -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}'
echo "############################"