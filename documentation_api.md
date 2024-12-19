Voici une version prête à copier-coller pour documenter vos APIs :

---

# Documentation des APIs

## **API de classification de texte**

### **Base URL**  
`http://<IP_EC2>:8000`


**POST /predict**

Effectue une classification de texte

- **Requête**  
  - **Méthode HTTP** : `POST`  
  - **Corps de la requête (JSON)** :  
    ```json
    {
      "text": "Exemple de texte à classifier"
    }
    ```

- **Réponse**  
  - **Format** : JSON  
  - **Exemple** :  
    ```json
    {
      "prediction": [
        {
          "label": "LABEL_1",
          "score": 0.95
        }
      ]
    }
    ```

- **Fonctionnement** :  
  - Log du texte dans MLflow comme paramètre.
  - Log du score de la prédiction dans MLflow comme métrique.

---

## **API de monitoring des métriques**

### **Base URL**  
`http://<IP_EC2>:8000`


**GET /metrics**  
Expose les métriques Prometheus

- **Requête**  
  - **Méthode HTTP** : `GET`  
  - **Corps** : Aucun

- **Réponse**  
  - **Format** : Texte brut au format Prometheus  

- **Métriques disponibles** :  
  - `request_count` : Nombre total de requêtes reçues.  
  - `request_duration_seconds` : Durée des requêtes en secondes.

---

## **Exemples d'utilisation**

### **1. Envoyer une requête pour classifier un texte**
```bash
curl -X POST "http://<IP_EC2>:8000/predict" \
-H "Content-Type: application/json" \
-d '{"text": "I love machine learning!"}'
```