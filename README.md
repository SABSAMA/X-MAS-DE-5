# Projet MLOps - Infrastructure AWS avec Terraform, Ansible, Docker, Prometheus et Grafana

## Table des matières
1. **Architecture du projet**
2. **Choix techniques et outils**
3. **Guide d'installation pas à pas**
4. **Configuration et déploiement des services**
5. **Intégration continue avec GitHub Actions**

---

## 1. Architecture du projet

Ce projet met en place une infrastructure MLOps complète sur AWS. L'architecture est conçue pour automatiser la configuration et le déploiement des services nécessaires au monitoring, au tracking des expériences ML et à l'exposition des métriques via une API.

### Composants principaux :
- **Instance EC2** : Héberge les services (Prometheus, Grafana, FastAPI, MLflow).
- **Terraform** : Automatise le déploiment de l'instance EC2.
- **Ansible** : Installe les differentes outils de base sur l'instance EC2.
- **Prometheus** : Collecte des métriques.
- **Grafana** : Visualisation des métriques.
- **API FastAPI** : Fournit des points d'accès REST pour exposer les métriques.
- **MLflow** : Gère le suivi des expériences de machine learning.
- **Docker** et **Docker Compose** : Conteneurisation et orchestration des services.

---

## 2. Choix techniques et outils

### **Terraform**
- Automatisation de la création des ressources AWS (EC2, groupes de sécurité, volumes EBS).
- Gestion d'infrastructure déclarative.

### **Ansible**
- Configuration automatisée de l'instance EC2 (installation de Docker et Docker Compose, configuration des services).

### **Docker Compose**
- Simplification de la gestion des conteneurs pour les services Prometheus, Grafana, MLflow et FastAPI.

### **Prometheus et Grafana**
- Monitoring et visualisation des métriques.

### **FastAPI**
- Fournit une API légère et rapide pour exposer des métriques.

---

## 3. Guide d'installation pas à pas

### Prérequis
- **AWS CLI** configuré.
- **Terraform** installé.
- **Ansible** installé.

### Étapes
1. **Cloner le repository**
   ```bash
   git clone https://github.com/SABSAMA/X-MAS-DE-5
   cd X-MAS-DE-5/infra/
   ```

2. **Configurer l'instance EC2 avec Ansible**
   ```bash
      ./script.sh
   ```
   Ce script automatise les étapes suivantes :
   - Récupération de l'IP publique de l'instance EC2.
   - Affichage de l'IP publique de l'instance EC2.
   - Ajout de cette IP dans `known_hosts` pour éviter les prompts SSH.
   - Déploiement des services via Ansible et Docker Compose.

3. **Accéder aux services déployés**
   - **Prometheus** : `http://<IP_EC2>:9090`
   - **Grafana** : `http://<IP_EC2>:3000` (compte admin/admin)
   - **API FastAPI** : `http://<IP_EC2>:8000`
   - **MLflow** : `http://<IP_EC2>:5000`

---

## 4. Configuration et déploiement des services

### Terraform
Fichier `main.tf` :
- Crée une instance EC2.
- Configure un groupe de sécurité pour autoriser les connexions SSH, et les ports 3000, 5000, 8000 et 9090.
- Génère une clé privée pour la connexion SSH.

### Ansible
Fichier `setup.yml` :
- Installe Docker et Docker Compose sur l'instance EC2.
- Copie les fichiers d'application sur l'instance.
- Lance les services avec Docker Compose.

### Docker Compose
Fichier `docker-compose.yml` :
- Définit les conteneurs pour Prometheus, Grafana, MLflow et l'API FastAPI.
- Monte les volumes nécessaires pour la configuration et les données persistantes.

---

## 5. Intégration continue avec GitHub Actions

### Fichier de workflow GitHub Actions
Un workflow est configuré pour exécuter le script d'installation automatiquement après chaque push sur la branche `main`.

```yaml
name: Run Shell Script

on:
  push:
    branches:
      - main

jobs:
  run-script:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Run script
        run: ./infra/script.sh
        shell: bash
```

### Fonctionnement
- À chaque push sur la branche `main`, GitHub Actions :
  1. Clone le code du repository.
  2. Exécute le script `./infra/script.sh` pour déployer ou mettre à jour l'infrastructure et les services.
