#!/bin/bash

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Install Prometheus Operator
echo "Installing Prometheus Operator..."
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/master/bundle.yaml
check_command "Failed to install Prometheus Operator"

# Wait for Prometheus Operator components to be ready
echo "Waiting for Prometheus Operator components to be ready..."
kubectl wait --namespace default --for=condition=Available deployment/prometheus-operator-operator --timeout=5m
check_command "Prometheus Operator deployment timed out"

# Create Prometheus instance for monitoring
echo "Creating Prometheus instance..."
kubectl apply -f ../../manifests/prometheus.yaml

check_command "Failed to create Prometheus instance"

# Wait for Prometheus pods to be ready
echo "Waiting for Prometheus pods to be ready..."
kubectl wait --namespace default --for=condition=Ready pod -l app=prometheus --timeout=5m
check_command "Prometheus pods deployment timed out"

# Create ServiceMonitor for NGINX Ingress Controller
echo "Creating ServiceMonitor for NGINX Ingress Controller..."
kubectl apply -f ../../manifests/servicemonitor.yaml
check_command "Failed to create ServiceMonitor for NGINX Ingress Controller"

echo "Prometheus setup completed successfully."
