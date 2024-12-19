FROM python:3.8-slim

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    pkg-config \
    libhdf5-dev \
    build-essential

# Installer les dépendances Python
RUN pip install --upgrade pip
RUN pip install fastapi uvicorn transformers mlflow torch

# Copier le code de l'application
COPY ./ /app
WORKDIR /app

EXPOSE 8000
CMD ["uvicorn", "api.app:app", "--host", "0.0.0.0", "--port", "8000"]
