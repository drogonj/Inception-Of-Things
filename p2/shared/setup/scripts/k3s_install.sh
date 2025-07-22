#!/bin/sh

set -e

##### Configuration #####
NODE_IP="192.168.56.110"
FLANNEL_IFACE="eth1"
K3S_TOKEN_FILE="/vagrant/token/token"

##### Vérifications initiales #####
echo "Vérification des prérequis..."
sudo apt-get update -y
sudo apt-get install -y curl net-tools vim git

##### Récupération du token #####
echo "Lecture du token K3s..."
if [ ! -f "$K3S_TOKEN_FILE" ]; then
    echo "ERREUR: Fichier token introuvable à $K3S_TOKEN_FILE"
    exit 1
fi

K3S_TOKEN=$(head -n 1 "$K3S_TOKEN_FILE")
if [ -z "$K3S_TOKEN" ]; then
    echo "ERREUR: Token vide ou invalide"
    exit 1
fi

##### Installation K3s #####
echo "Installation de K3s..."

curl -sfL https://get.k3s.io | sh -s - \
    --node-ip "$NODE_IP" \
    --node-external-ip "$NODE_IP" \
    --flannel-iface "$FLANNEL_IFACE" \
    --write-kubeconfig-mode 644 \
    --token "$K3S_TOKEN"

##### Vérification post-install #####
echo "Vérification de l'installation..."
k3s kubectl get nodes -o wide
k3s kubectl get pods -A

echo "Installation de K3s terminée avec succès!"