#!/bin/bash

# 1. Créer l'infrastructure avec Terraform
echo "Création de l'infrastructure avec Terraform..."
terraform init
terraform apply -auto-approve

# 2. Récupérer l'IP publique de l'instance EC2
echo "Récupération de l'IP publique de l'instance EC2..."
PUBLIC_IP=$(terraform output -raw instance_public_ip)
echo "L'IP publique de l'instance EC2 est : $PUBLIC_IP"

# 3. Récupérer le chemin de la clé privée générée par Terraform
PRIVATE_KEY_PATH=$(terraform output -raw private_key_path)
echo "Le chemin de la clé privée AWS générée est : $PRIVATE_KEY_PATH"

# 4. Ajouter l'IP de l'instance à known_hosts pour éviter le prompt de confirmation
echo "Ajout de l'IP de l'instance à known_hosts..."
ssh-keyscan -H "$PUBLIC_IP" >> ~/.ssh/known_hosts

# 5. Lancer Ansible pour configurer l'instance
echo "Démarrage de la configuration de l'instance via Ansible..."
ansible-playbook -i "$PUBLIC_IP," --private-key "$PRIVATE_KEY_PATH" setup.yml -e "ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"

echo "Configuration terminée avec succès!"
