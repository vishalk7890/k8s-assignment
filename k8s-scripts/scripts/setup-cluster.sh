
#!/bin/bash

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Install k3s on the master node (server)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-init" sh -
check_command "Failed to install k3s"

# Wait for k3s server to start
sleep 10

# Get the k3s server token
K3S_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
check_command "Failed to get k3s server token"

# Get the IP address of the current machine
IP_ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
check_command "Failed to get IP address"

# Install kubectl on the master node
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
check_command "Failed to copy k3s config to kubeconfig"
sudo chown $(id -u):$(id -g) $HOME/.kube/config
check_command "Failed to change ownership of kubeconfig"
export KUBECONFIG=$HOME/.kube/config

#for worker nodes

echo "Kubernetes server setup completed successfully."
echo "Use the following command to configure worker nodes:"
echo "export K3S_URL=https://$IP_ADDRESS:6443"
echo "export K3S_TOKEN=$K3S_TOKEN"
#echo "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--token $K3S_TOKEN --server $K3S_URL' sh -"

