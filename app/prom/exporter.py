from prometheus_client import start_http_server, Counter, Summary
import time
from fastapi import FastAPI
from prometheus_client import generate_latest

# Initialisation de l'application FastAPI et des métriques Prometheus
app = FastAPI()

# Définition des métriques
REQUEST_COUNT = Counter('request_count', 'Nombre de requêtes traitées')
REQUEST_DURATION = Summary('request_duration_seconds', 'Durée des requêtes')

@app.middleware("http")
async def monitor_request(request, call_next):
    start_time = time.time()
    response = await call_next(request)
    duration = time.time() - start_time
    REQUEST_DURATION.observe(duration)
    REQUEST_COUNT.inc()  # Incrémente le compteur
    return response

@app.get("/metrics")
def metrics():
    # Expose les métriques au format Prometheus
    return generate_latest()

# Démarre un serveur HTTP pour exposer les métriques
if __name__ == "__main__":
    start_http_server(8001)
