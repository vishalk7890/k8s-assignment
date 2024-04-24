#!/bin/bash


INGRESS_NGINX_NAMESPACE="ingress-nginx"
if ! kubectl get namespace "$INGRESS_NGINX_NAMESPACE" &> /dev/null; then
    echo "Creating namespace $INGRESS_NGINX_NAMESPACE"
    kubectl create namespace "$INGRESS_NGINX_NAMESPACE" || { echo "Error creating namespace $INGRESS_NGINX_NAMESPACE"; exit 1; }
fi

echo "Deleting existing NGINX Ingress Controller resources, if any"
helm delete nginx-ingress --namespace "$INGRESS_NGINX_NAMESPACE" &> /dev/null || true

echo "Installing NGINX Ingress Controller"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace "$INGRESS_NGINX_NAMESPACE"  --set controller.service.type=NodePort || { echo "Error installing NGINX Ingress Controller"; exit 1; }

echo "Waiting for NGINX Ingress Controller pods to be ready"

kubectl wait --namespace "$INGRESS_NGINX_NAMESPACE" \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s || { echo "Error: Timed out waiting for NGINX Ingress Controller pods to be ready"; exit 1; }

#check pod ready
POD_COUNT=$(kubectl get pods -n "$INGRESS_NGINX_NAMESPACE" --selector=app.kubernetes.io/component=controller --field-selector=status.phase=Running | grep -c "1/1")
if [ $POD_COUNT -eq 0 ]; then
    echo "Error: NGINX Ingress Controller pods are not ready"
    exit 1
fi

echo "NGINX Ingress Controller setup completed successfully in namespace $INGRESS_NGINX_NAMESPACE."
