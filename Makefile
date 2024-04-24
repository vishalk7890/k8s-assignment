.PHONY: setup-cluster deploy-services setup-ingress-controller setup-prometheus generate-metrics run-all

setup-cluster:
	@echo "Setting up Kubernetes cluster..."
	@./k8s-scripts/script/setup-cluster.sh

setup-multinode:
	@echo "setting up multinode"
	@./k8s-scripts/script/worker-nodes.sh
deploy-services:
	@echo "Deploying services..."
	@./k8s-scripts/script/resource.sh
	

setup-ingress-controller:
	@echo "Setting up Ingress Controller..."
	@./k8s-scripts/scripts/ingress-controller.sh

setup-prometheus:
	@echo "Setting up Prometheus..."
	@./k8s-scripts/scripts/prom.sh

generate-metrics:
	@echo "Generating metrics..."
	@./k8s-scripts/script.sh

run-all: setup-cluster deploy-services setup-ingress-controller setup-prometheus generate-metrics
	@echo "All steps completed successfully."
