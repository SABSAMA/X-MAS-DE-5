#!/bin/bash

echo "Arrêt de toutes les instances EC2 en cours d'exécution..."
terraform destroy -auto-approve

# 1. Créer l'infrastructure avec Terraform
echo "Création de l'infrastructure avec Terraform..."
terraform init
terraform apply -auto-approve

# 2. Récupérer l'IP publique de l'instance EC2
echo "Récupération de l'IP publique de l'instance EC2..."
PUBLIC_IP=$(terraform output -raw instance_public_ip)
echo "IP publique de l'instance EC2 est : $PUBLIC_IP"

# 3. Récupérer le chemin de la clé privée générée par Terraform
PRIVATE_KEY_PATH=$(terraform output -raw private_key_path)
echo "Le chemin de la clé privée AWS générée est : $PRIVATE_KEY_PATH"

# 4. Ajouter l'IP de l'instance à known_hosts pour éviter le prompt de confirmation
echo "Ajout de l'IP de l'instance à known_hosts..."
ssh-keyscan -H "$PUBLIC_IP" >> ~/.ssh/known_hosts

# 5. Lancer Ansible pour configurer l'instance
echo "Démarrage de la configuration de l'instance via Ansible..."

# Sleep pour attendre que le serveur démarre coté AWS
sleep 10

ansible-playbook -i "$PUBLIC_IP," --private-key "$PRIVATE_KEY_PATH" setup.yml -e "ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"

# Boucle jusqu'à ce que la configuration via Ansible réussisse
while true; do
    ansible-playbook -i "$PUBLIC_IP," --private-key "$PRIVATE_KEY_PATH" setup.yml -e "ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"
    
    # Vérifier si la commande Ansible a réussi
    if [ $? -eq 0 ]; then
        echo "Configuration réussie !"
        break
    else
        echo "La configuration a échoué. Nouvelle tentative dans 5 secondes..."
        sleep 5
    fi
done

echo "GRAFANA => $PUBLIC_IP:3000"
echo "PROMETHEUS => $PUBLIC_IP:9090"
echo "MFLOW => $PUBLIC_IP:5000"
echo "API => $PUBLIC_IP:8000"
