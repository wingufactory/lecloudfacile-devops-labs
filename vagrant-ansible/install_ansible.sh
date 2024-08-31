#!/bin/bash

# install des mises à jour
sudo apt update -y

#installation de git
sudo apt install git -y

# installation des mises à jour
sudo apt update -y

# Install ansible
sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Création de group user 
sudo groupadd -g 1200 ansible

# Création d'un user ansible
sudo useradd -u 1200 -g 1200 -m -c "[lancement des playboks] User Ansible" -s /bin/bash ansible

# Attribution des droits
cd /home
sudo chmod 775 /home/ansible
sudo chown -R ansible:ansible ansible

# Ajout des droits sudo à ansible
sudo echo "ansible  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# DNS
sudo echo "192.168.10.1 ansible" >> /etc/hosts
sudo echo "192.168.10.2 target" >> /etc/hosts