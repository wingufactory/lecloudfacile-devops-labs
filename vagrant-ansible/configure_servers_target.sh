#!/bin/bash

# install des mises à jour
sudo apt update -y

# Création de group user 
sudo groupadd -g 1200 ansible

# Création d'un user ansible
sudo useradd -u 1200 -g 1200 -m -c "[lancement des playboks] User Ansible" -s /bin/bash ansible

# Ajout des droits sudo à ansible
sudo echo "ansible  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Création de répertoire ssh
sudo mkdir /home/ansible/.ssh
sudo touch /home/ansible/.ssh/authorized_keys
sudo chown -R ansible:ansible /home/ansible

# DNS
sudo echo "192.168.10.1 ansible" >> /etc/hosts
sudo echo "192.168.10.2 target" >> /etc/hosts