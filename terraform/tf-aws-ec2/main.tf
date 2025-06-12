terraform {

  # Déclaration des providers requis
  required_providers {

    # Dans cet section, on doit avoir minimun 1 provider
    # Ajout du provider AWS

    aws = {

      # Provider fournit par Hashicorp mais pas AWS
      source = "hashicorp/aws" 

      # Version du provider utilisé
      version = "5.63.0" 
    }
  }
}
# Configuration du provider
provider "aws" {

  # Spécification de la région pour la création des ressources
  region  = "us-east-1"
  profile = "default"
}


# Déclarition de variables locales
locals {
  service_name = "app"
  owner        = "lecloudfacile"
}

# Déclaration de variables Input
variable "instance_type" {

  # type de la variable
  type = string

  # Valeur par défaut si elle n'est pas mentionné dan sle fichier tfvars our fourni à l'execution

  default = "t2.micro"
}

# Déclaration d'une ressource EC2
resource "aws_instance" "TfServer00" {
  ami           = "ami-066784287e358dad1"
  instance_type = var.instance_type


  tags = {
      # Substitution de la variable local sur le tag
    Name = "TfServer00-${local.service_name}"
  }
}

# Déclaration de variable output
output "instance_public_ip_addr" {
  value = aws_instance.TfServer00.public_ip
}

