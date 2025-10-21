# Use an Airflow image that exists (2.x). 2.9.x is stable and matches your earlier logs.
FROM apache/airflow:2.9.0-python3.11

USER root
# (Optional) OS utilities you might like during debugging
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl vim git && \
    rm -rf /var/lib/apt/lists/*

USER airflow

# Copy requirements
COPY requirements.txt /requirements.txt

# Install Python deps (respect Airflow constraints for non-PyTorch deps)
# Then install PyTorch CPU wheels from the official PyTorch index.
RUN pip install --no-cache-dir -r /requirements.txt && \
    pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu \
        torch torchvision torchaudio

# Create a place for MLflow’s local file store
RUN mkdir -p /opt/airflow/mlruns

# Default envs you’ll probably want for MLflow inside tasks
# ENV MLFLOW_TRACKING_URI="file:///opt/airflow/mlruns"

# (No CMD here; services set their own commands in docker-compose)
