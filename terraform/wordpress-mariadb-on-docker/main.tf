#cette ligne permet de configurer les providers necessaires à la configuration de cet infra

#ce bloc indique que la configuration va s'appliquer à tout le projet terraform*/

terraform {

  #ce bloc permet de specifier les providers
  required_providers {

    #ici nous allons utiliser le provider docker
    docker = {

      #Indique la source de ce provider
      source = "kreuzwerker/docker"

      #indique la version du provider utilisée
      version = "~> 3.0.1"
    }
  }
}


#indique qu'on va utiliser le provider docker avec un configuration specifique.
# {} signifie que nous allons utiliser les configurations par defaut de ce provider provider "docker" {} 


#indique la creation d'une ressource docker_network pour faciliter la communication entre les conteneurs docker
resource "docker_network" "private_network" {
  name = "wp_net"
}

#indique la creation d'une ressource docker_volume pour faciliter le stockage de donnees de la DB
resource "docker_volume" "wp_vol_db" {
  name = "wp_vol_db"
}

#indique la creation d'une ressource docker_volume pour faciliter le stockage de donnees de wordpress
resource "docker_volume" "wp_vol_html" {
  name = "wp_vol_html"
}

#indique la creation d'une ressource docker_container pour la BD
resource "docker_container" "db" {
  name         = "db"
  image        = "mariadb"
  restart      = "always"
  network_mode = "wp_net"

  #montage du volume de donnees vers le repertoire /var/lib/mysql
  mounts {
    type   = "volume"
    target = "/var/lib/mysql"
    source = "wp_vol_db"
  }

  #Specification des creds de la base de données en sustituant avec les variables définies dans le fichier variables.tf
  env = [
    "MYSQL_ROOT_PASSWORD=${var.db_root_password}",
    "MYSQL_DATABASE=${var.db_name}",
    "MYSQL_USER=${var.db_user}",
    "MYSQL_PASSWORD=${var.db_password}"
  ]
}

#indique la creation d'une ressource docker_container pour wordpress
resource "docker_container" "wordpress" {
  name         = "wordpress"
  image        = "wordpress:latest"
  restart      = "always"
  network_mode = "wp_net"
  env = [
    "WORDPRESS_DB_HOST=db",
    "WORDPRESS_DB_USER=${var.db_user}",
    "WORDPRESS_DB_PASSWORD=${var.db_password}",
    "WORDPRESS_DB_NAME=${var.db_name}"
  ]

  #exposition des ports wordpress vers le port 8080
  ports {
    internal = "80"
    external = "8080"
  }
  mounts {
    type   = "volume"
    target = "/var/www/html"
    source = "wp_vol_html"
  }
}