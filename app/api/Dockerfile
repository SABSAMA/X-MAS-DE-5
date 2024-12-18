FROM python:3.8-slim

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libhdf5-dev \
    build-essential

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install fastapi uvicorn transformers mlflow torch


# Copy application code
COPY ./ /app
WORKDIR /app

EXPOSE 8000
CMD ["uvicorn", "api.app:app", "--host", "0.0.0.0", "--port", "8000"]
