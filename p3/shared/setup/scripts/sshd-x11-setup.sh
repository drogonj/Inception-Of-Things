#!/bin/sh

set -e 

echo "Installation des dependances et utilitaires pour le portforwarding X11..."
sudo apt-get install -y \
    xorg \
    chromium

sudo sed -i 's/#X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config

sudo systemctl restart sshd
