# Project Name

This project demonstrates a setup for deploying services on Kubernetes and monitoring them using Prometheus.

## Prerequisites

Before running the scripts, ensure you have the following installed:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/): Kubernetes command-line tool.
- [helm](https://helm.sh/docs/intro/install/): Package manager for Kubernetes.
- [jq](https://stedolan.github.io/jq/download/): Command-line JSON processor.
- [k3s](https://k3s.io/): Lightweight Kubernetes distribution.

## Setup Single or Multi-Cluster Node with k3s
To set up single node cluster, follow the step:
1. **Single node**:
    ```bash
    make setup-cluster

To set up a multi-cluster node with k3s using SSH key authentication, follow these steps:

1. **Generate SSH Key Pair**:
   Generate an SSH key pair if you haven't already:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

2. **Copy Public Key to Remote Nodes**:
    ```bash
    ssh-copy-id username@remote_node_ip
3. **Run worker-nodes.sh**:
    ```bash
    make setup-multinode


## Steps to Run

1. **Setup Kubernetes Cluster**:
    ```bash
    make setup-cluster
    ```

2. **Deploy Services**:
    ```bash
    make deploy-services
    ```

3. **Setup Ingress Controller**:
    ```bash
    make setup-ingress-controller
    ```

4. **Setup Prometheus**:
    ```bash
    make setup-prometheus
    ```

5. **Generate Metrics**:
    ```bash
    make generate-metrics
    ```

To run all steps sequentially, use:
```bash
make run-all
```
# Notes

Each script in the k8s-scripts/scripts directory handles a specific task related to the Kubernetes setup and service deployment.
Manifest files in the manifests directory define Kubernetes resources such as deployments, services, and ingresses.
The benchmark/script.sh file performs benchmarking using Apache Bench (ab) against the deployed services.