import mlflow
from mlflow.tracking import MlflowClient

# Configuration MLflow
mlflow.set_tracking_uri("http://mlflow:5000")
client = MlflowClient()

# Création d'un nouvel expériment si nécessaire
experiment_name = "text_classification"
if not client.get_experiment_by_name(experiment_name):
    mlflow.create_experiment(experiment_name)
print(f"MLflow experiment '{experiment_name}' is ready.")
