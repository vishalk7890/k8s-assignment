#!/bin/bash


check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

PROMETHEUS_URL="http://localhost:9090"

# average requests per second
QUERY_REQUESTS_PER_SECOND='rate(nginx_ingress_controller_requests{job="kubernetes-service-endpoints"}[1m])'

# average memory usage per second
QUERY_MEMORY_USAGE='avg_over_time(container_memory_usage_bytes{container_name!="POD",container_name!="",pod!="",namespace!="kube-system"}[1m])'

#  average CPU usage per second
QUERY_CPU_USAGE='avg_over_time(container_cpu_usage_seconds_total{container_name!="POD",container_name!="",pod!="",namespace!="kube-system"}[1m])'

# Execute queries and save results to CSV file
echo "Timestamp,Average_Requests_Per_Second,Average_Memory_Usage_Per_Second,Average_CPU_Usage_Per_Second" > metrics.csv
curl -sG --data-urlencode "query=$QUERY_REQUESTS_PER_SECOND" "$PROMETHEUS_URL/api/v1/query_range?step=1m" | jq -r '.data.result[] | "\(.value[0]),\(.value[1])"' >> metrics.csv
curl -sG --data-urlencode "query=$QUERY_MEMORY_USAGE" "$PROMETHEUS_URL/api/v1/query_range?step=1m" | jq -r '.data.result[] | "\(.value[0]),\(.value[1])"' >> metrics.csv
curl -sG --data-urlencode "query=$QUERY_CPU_USAGE" "$PROMETHEUS_URL/api/v1/query_range?step=1m" | jq -r '.data.result[] | "\(.value[0]),\(.value[1])"' >> metrics.csv

echo "CSV file generated successfully: metrics.csv"
