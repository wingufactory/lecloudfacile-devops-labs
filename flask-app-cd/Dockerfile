# Utilisation d'une image de base python
FROM python:3.10.14-alpine

# Définition de variable d'environnement
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV HOME=/app

# Définition d'un répertoire de travail à l'intérieur du conteneur temporaire
WORKDIR ${HOME}

# Copie du fichier des dépendances
COPY requirements.txt ${HOME}/requirements.txt

# Installation des dépendances
RUN pip3 install -r ${HOME}/requirements.txt

# Copie des fichiers sources
COPY app/ ${HOME}/

# Exposition du port de l'application
EXPOSE 8000

# Indication de la commande de démarrage de l'application lorsque l'image sera en execution
CMD ["gunicorn","--workers=1" ,"--timeout=3600", "--bind", "0.0.0.0:8000","app:app"]
