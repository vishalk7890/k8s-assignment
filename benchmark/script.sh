#!/bin/bash

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Install Apache Bench (ab)
echo "Installing Apache Bench (ab)..."
sudo apt-get update
sudo apt-get install -y apache2-utils
check_command "Failed to install Apache Bench (ab)"

# Perform benchmarking using Apache Bench (ab)
echo "Benchmarking /foo endpoint..."
ab -n 1000 -c 10 http://localhost/foo
check_command "Failed to benchmark /foo endpoint"

echo "Benchmarking /bar endpoint..."
ab -n 1000 -c 10 http://localhost/bar
check_command "Failed to benchmark /bar endpoint"

echo "Benchmarking completed successfully."
