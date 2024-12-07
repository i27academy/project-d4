#!/bin/bash

# Function to dynamically fetch service info
get_service_info() {
    # Fetch the external Node IP and NodePorts for Prometheus and Grafana
    NODE_IP=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[?(@.type=='ExternalIP')].address}")
    PROMETHEUS_PORT=$(kubectl get svc prometheus-server-ext -o jsonpath="{.spec.ports[0].nodePort}" 2>/dev/null)
    GRAFANA_PORT=$(kubectl get svc grafana-ext -o jsonpath="{.spec.ports[0].nodePort}" 2>/dev/null)
    echo "$NODE_IP:$PROMETHEUS_PORT $NODE_IP:$GRAFANA_PORT"
}

# Check if Prometheus is already installed
if helm list --all-namespaces | grep -q prometheus; then
    echo "⚠️ Prometheus is already installed. Skipping installation."
else
    # Search for Prometheus in the Helm hub
    echo "🔎 Searching for Prometheus in the Helm hub..."
    helm search hub Prometheus
    # Add the Prometheus Helm repo
    echo "📥 Adding the Prometheus community Helm repo..."
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    # Update Helm repos
    echo "🔄 Updating Helm repos..."
    helm repo update
    # Install Prometheus

    echo "🚀 Installing Prometheus from the Helm repo..."
    helm install prometheus prometheus-community/prometheus

    echo "🌐 Exposing Prometheus service with NodePort..."
    kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
fi

# Install kube-state-metrics
echo "🔍 Checking if kube-state-metrics is installed..."
if helm list --namespace kube-system | grep -q kube-state-metrics; then
    echo "⚠️ kube-state-metrics is already installed in the kube-system namespace. Skipping installation."
else
    echo "🚀 Installing kube-state-metrics in the kube-system namespace..."
    helm install kube-state-metrics prometheus-community/kube-state-metrics --namespace kube-system
fi

# Call the Grafana setup script
echo "🔗 Calling Grafana setup script..."
if [ -f ./setup-grafana.sh ]; then
    ./setup-grafana.sh
else
    echo "❌ Grafana setup script not found! Ensure the script exists in the same directory."
    exit 1
fi

# Wait for a few seconds to ensure services are up
echo "⏳ Waiting for services to stabilize..."
sleep 5

# Get the Node IP and service ports dynamically
echo "🔍 Fetching Node IP and service ports dynamically..."
SERVICE_INFO=$(get_service_info)
NODE_IP=$(echo "$SERVICE_INFO" | awk '{print $1}' | cut -d':' -f1)
PROMETHEUS_PORT=$(echo "$SERVICE_INFO" | awk '{print $1}' | cut -d':' -f2)
GRAFANA_PORT=$(echo "$SERVICE_INFO" | awk '{print $2}' | cut -d':' -f2)

PROMETHEUS_URL="http://$NODE_IP:$PROMETHEUS_PORT"
GRAFANA_URL="http://$NODE_IP:$GRAFANA_PORT"

# Display the URLs
if [[ -z $PROMETHEUS_PORT || -z $GRAFANA_PORT ]]; then
    echo "❌ Failed to retrieve service ports! Verify that services are exposed as NodePort."
else
    echo "🔗 Access Prometheus at: $PROMETHEUS_URL"
    echo "🔗 Access Grafana at: $GRAFANA_URL"
fi

# Check if the Grafana secret exists
echo "🔍 Checking if Grafana admin password secret exists..."
if kubectl -n default get secret grafana >/dev/null 2>&1; then
    echo "🔑 Retrieving the Grafana admin password..."
    GRAFANA_PASSWORD=$(kubectl -n default get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
    echo "🛡️ Grafana Admin Password: $GRAFANA_PASSWORD"
else
    echo "❌ Grafana secret not found! Ensure Grafana is properly deployed and configured."
fi
