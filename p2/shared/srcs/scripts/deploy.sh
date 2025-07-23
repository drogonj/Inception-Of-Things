#!/bin/sh

set -e

export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

echo "=== En attente de l'initialisation de Kubernetes ==="
until kubectl get nodes; do
  echo "En attente de l'initialisation de Kubernetes..."
  sleep 5
done

echo "=== Nettoyage si nécessaire ==="
helm uninstall app1 app2 app3 --ignore-not-found --namespace inception-of-things
kubectl delete namespace inception-of-things --ignore-not-found

echo "=== Déploiement des applications IoT ==="

echo "1/4 - Création du namespace..."
kubectl apply -f /vagrant/srcs/namespaces/iot-ns.yaml

echo "2/4 - Déploiement des applications..."
cd /vagrant/srcs

helm install app1 ./helm-chart -f ./apps-values/app1-values.yaml -n inception-of-things
helm install app2 ./helm-chart -f ./apps-values/app2-values.yaml -n inception-of-things
helm install app3 ./helm-chart -f ./apps-values/app3-values.yaml -n inception-of-things

echo "3/4 - Configuration de l'ingress..."
kubectl apply -f ./ingress/iot-ingress.yaml

echo "4/4 - Vérification..."
kubectl get pods -n inception-of-things
kubectl get svc -n inception-of-things
kubectl get ingress -n inception-of-things

echo "=== Déploiement terminé avec succès! ==="