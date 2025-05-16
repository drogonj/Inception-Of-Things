#!/bin/sh

##### K3S_TOKEN #####
echo "Retrieving k3s token..."
if k3s_token=`head -n 1 /vagrant/token/token 2>/dev/null | base64` ; then
    if [ -z "$k3s_token" ] ; then
        echo "Token not provided / empty. Exiting..."
        exit 1
    else
        echo "Token extracted successfully !"
    fi
else
    echo "Failed to open/read token file. Exiting..."
    exit 1
fi
echo ""
##### Installing dependencies #####

echo "Installing dependencies..."

sudo apt update -y
sudo apt install curl -y

echo "Dependencies installed !"
echo ""
##### K3S Installation #####

echo "Installing K3S..."

node_ip="192.168.56.110"

curl -sfL https://get.k3s.io | \
    INSTALL_K3S_EXEC="server --node-ip $node_ip" sh -s - \
    --write-kubeconfig-mode 644 \
    --token $k3s_token
