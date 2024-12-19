import mlflow
import mlflow.sklearn
from fastapi import FastAPI
from pydantic import BaseModel
from transformers import pipeline

app = FastAPI()

# Initialisation du pipeline Hugging Face
classifier = pipeline("text-classification", model="distilbert-base-uncased")

# Définition du modèle de requête
class TextRequest(BaseModel):
    text: str

@app.post("/predict")
def predict(request: TextRequest):
    # Démarre un suivi dans MLflow
    with mlflow.start_run():
        # Log du modèle dans MLflow
        mlflow.log_param("text", request.text)
        
        # Effectue la prédiction
        prediction = classifier(request.text)
        
        # Log de la prédiction dans MLflow
        mlflow.log_metric("prediction_score", prediction[0]["score"])
        return {"prediction": prediction}
