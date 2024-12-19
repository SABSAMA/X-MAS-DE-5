FROM python:3.8-slim

# Installer les dépendances nécessaires
RUN pip install prometheus_client fastapi uvicorn

# Copier le fichier d'exportation des métriques
COPY ./ /app

WORKDIR /app

# Exposer le port
EXPOSE 8001

# Lancer le script pour exporter les métriques
CMD ["python", "/app/exporter.py"]
