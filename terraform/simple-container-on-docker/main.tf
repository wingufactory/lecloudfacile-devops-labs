terraform {

  # Déclaration des providers requis
  required_providers {

    # Ajout du provider Docker
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# Configuration du provider
provider "docker" {}

# Déclaration d'une ressource - image Docker
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Déclaration d'une ressource - conteneur Docker
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  # Exposition du port 80 du conteneur sur le port 8000 de a machine hôte
  ports {
    internal = 80
    external = 8090
  }
}
