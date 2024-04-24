#!/bin/bash

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if SSH key and master hostname are provided as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <ssh_key_path> <master_hostname>"
    exit 1
fi

SSH_KEY="$1"
MASTER_HOSTNAME="$2"

# Get the IP address of the master node
MASTER_IP=$(ssh -i "$SSH_KEY" "$MASTER_HOSTNAME" "hostname -I | cut -d ' ' -f1")
check_command "Failed to retrieve IP address of master node"

# Install k3s on the worker node
export K3S_URL=https://$MASTER_IP:6443
export K3S_TOKEN="WORKER_NODE_TOKEN"  # Replace with the k3s token obtained from the master node
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--token $K3S_TOKEN --server $K3S_URL" sh -
check_command "Failed to install k3s on worker node"

echo "Kubernetes worker node setup completed successfully."
