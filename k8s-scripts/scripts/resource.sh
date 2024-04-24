#!/bin/bash

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Apply backend services
echo "Applying backend services..."
kubectl apply -f ../../manifest.yaml
echo "Resources applied successfully."
