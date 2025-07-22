#!/bin/sh

##### Configuration #####
NODE_IP="192.168.56.111"
MASTER_IP="192.168.56.110"
FLANNEL_IFACE="eth1"
K3S_TOKEN_FILE="/vagrant/token/token"

##### Vérifications initiales #####
echo "Vérification des prérequis..."
sudo apt-get update -y
sudo apt-get install -y curl net-tools vim

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

##### Recuperation de la configuration kube du serveur #####
until [ -f /vagrant/k3s.yaml ]; do
    echo "Attente de la configuration kube du serveur..."
    sleep 5
done
export KUBECONFIG="/vagrant/k3s.yaml"
echo "export KUBECONFIG=\"/vagrant/k3s.yaml\"" >> ~/.bashrc
echo "export KUBECONFIG=\"/vagrant/k3s.yaml\"" >> /home/vagrant/.bashrc
chown vagrant:vagrant /home/vagrant/.bashrc

##### Installation K3s #####
curl -sfL https://get.k3s.io | sh -s - \
    agent \
    --server "https://$MASTER_IP:6443" \
    --node-ip "$NODE_IP" \
    --token "$K3S_TOKEN"

##### Vérification post-install #####
echo "Vérification de l'installation..."
k3s kubectl get nodes -o wide
k3s kubectl get pods -A

echo "Installation terminée avec succès!"