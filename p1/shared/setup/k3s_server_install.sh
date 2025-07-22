#!/bin/sh

##### Configuration #####
NODE_IP="192.168.56.110"
FLANNEL_IFACE="eth1"
K3S_TOKEN_FILE="/vagrant/token/token"

##### Vérifications initiales #####
echo "Vérification des prérequis..."
sudo apt update -y
sudo apt install -y curl net-tools vim git

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
    server \
    --node-ip "$NODE_IP" \
    --node-external-ip "$NODE_IP" \
    --flannel-iface "$FLANNEL_IFACE" \
    --disable traefik \
    --disable servicelb \
    --write-kubeconfig-mode 644 \
    --token "$K3S_TOKEN"

###### Installation de K9s #####
sudo apt install -y /vagrant/k9s_linux_amd64.deb
export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
echo "export KUBECONFIG=\"/etc/rancher/k3s/k3s.yaml\"" >> ~/.bashrc
echo "export KUBECONFIG=\"/etc/rancher/k3s/k3s.yaml\"" >> /home/vagrant/.bashrc
chown vagrant:vagrant /home/vagrant/.bashrc

##### Partage de la configuration kube #####
cp /etc/rancher/k3s/k3s.yaml /vagrant/k3s.yaml
sed -i "s/127.0.0.1/$NODE_IP/g" /vagrant/k3s.yaml

##### Vérification post-install #####
echo "Vérification de l'installation..."
k3s kubectl get nodes -o wide
k3s kubectl get pods -A
k9s version

echo "Installation terminée avec succès!"