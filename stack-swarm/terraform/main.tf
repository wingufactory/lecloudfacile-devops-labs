# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nom de la clé SSH AWS"
  type        = string
  # Remplacez par le nom de votre paire de clés AWS
  default     = "your-key-pair-name"
}

# Provider AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source pour obtenir le VPC par défaut
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group pour Docker Swarm
resource "aws_security_group" "docker_swarm_sg" {
  name_prefix = "docker-swarm-sg"
  description = "Security group pour Docker Swarm cluster"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker Swarm - Communication avec et entre les nœuds
  ingress {
    description = "Docker Swarm Management"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    self        = true
  }

  # Docker Swarm - Découverte des nœuds (TCP)
  ingress {
    description = "Docker Swarm Node Discovery TCP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    self        = true
  }

  # Docker Swarm - Découverte des nœuds (UDP)
  ingress {
    description = "Docker Swarm Node Discovery UDP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    self        = true
  }

  # Docker Swarm - Trafic overlay network
  ingress {
    description = "Docker Swarm Overlay Network"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  # Tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker-swarm-security-group"
  }
}

# User data pour l'installation de Docker
locals {
  user_data = <<-EOF
#!/bin/bash
# Update the package database
sudo apt update -y

# Install necessary prerequisites
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's official APT repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package database with Docker packages
sudo apt update -y

# Install Docker CE (Community Edition)
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add 'ubuntu' user to the docker group to run Docker without sudo
sudo usermod -aG docker ubuntu

# Log installation completion
echo "Docker installation completed at $(date)" >> /var/log/docker-install.log
EOF
}

# Instance EC2 - Manager Node
resource "aws_instance" "lcf_manager_node" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.docker_swarm_sg.id]
  subnet_id             = data.aws_subnets.default.ids[0]
  
  user_data = base64encode(local.user_data)

  tags = {
    Name = "lcf_manager_node"
    Role = "manager"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }
}

# Instances EC2 - Worker Nodes
resource "aws_instance" "lcf_worker_node" {
  count                  = 2
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.docker_swarm_sg.id]
  subnet_id             = data.aws_subnets.default.ids[0]
  
  user_data = base64encode(local.user_data)

  tags = {
    Name = "lcf_worker_node_${count.index + 1}"
    Role = "worker"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }
}

# Outputs
output "manager_node_public_ip" {
  description = "Adresse IP publique du nœud manager"
  value       = aws_instance.lcf_manager_node.public_ip
}

output "manager_node_private_ip" {
  description = "Adresse IP privée du nœud manager"
  value       = aws_instance.lcf_manager_node.private_ip
}

output "worker_nodes_public_ips" {
  description = "Adresses IP publiques des nœuds workers"
  value       = aws_instance.lcf_worker_node[*].public_ip
}

output "worker_nodes_private_ips" {
  description = "Adresses IP privées des nœuds workers"
  value       = aws_instance.lcf_worker_node[*].private_ip
}

output "ssh_connection_manager" {
  description = "Commande SSH pour se connecter au manager"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.lcf_manager_node.public_ip}"
}

output "ssh_connection_workers" {
  description = "Commandes SSH pour se connecter aux workers"
  value = [
    for i, instance in aws_instance.lcf_worker_node : 
    "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${instance.public_ip}"
  ]
}

output "docker_swarm_setup_commands" {
  description = "Commandes pour configurer Docker Swarm"
  value = <<-EOT
# 1. Se connecter au manager node et initialiser le swarm:
ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.lcf_manager_node.public_ip}
sudo docker swarm init --advertise-addr ${aws_instance.lcf_manager_node.private_ip}

# 2. Récupérer le token de jointure:
sudo docker swarm join-token worker

# 3. Se connecter à chaque worker node et exécuter la commande join affichée
EOT
}
