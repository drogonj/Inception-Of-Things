#!/bin/bash

set -e

# Read PRIVATE_TOKEN from stdin
echo "Personnal Access Token (PRIVATE_TOKEN):"
read -r PRIVATE_TOKEN

echo "Creating new GitLab project..."
curl --request POST \
    --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" \
    --data "name=webapp&visibility=public" \
    "https://gitlab.192.168.56.110.nip.io/api/v4/projects"

echo "Creating webapp repository..."
git clone https://oauth2:$PRIVATE_TOKEN@gitlab.192.168.56.110.nip.io/root/webapp.git /home/vagrant/webapp

cp -r /vagrant/confs/webapp/* /home/vagrant/webapp/
chmod -R 755 /home/vagrant/webapp

echo "Configuring GIT..."
git config --global user.name "ngalzand"
git config --global user.email "ngalzand@example.com"

echo "Adding webapp files to repository..."
cd /home/vagrant/webapp
git add .
git commit -m "Initial commit"
git push origin master --force

echo "Webapp repository created and files pushed successfully!"
echo "Applying ArgoCD application configuration..."
kubectl apply -f /vagrant/confs/argocd/applications/webapp.yaml
