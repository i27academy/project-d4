#!/bin/bash

# Check if Grafana is already installed
if helm list --all-namespaces | grep -q grafana; then
    echo "⚠️ Grafana is already installed. Skipping installation."
else
    # Search for Grafana in the Helm hub
    echo "🔎 Searching for Grafana in the Helm hub..."
    helm search hub grafana

    # Add the Grafana Helm repo
    echo "📥 Adding the Grafana Helm repo..."
    helm repo add grafana https://grafana.github.io/helm-charts 

    # Update Helm repos
    echo "🔄 Updating Helm repos..."
    helm repo update

    # Install Grafana with admin password and disable initial admin password creation
    echo "🚀 Installing Grafana from the Helm repo with custom admin password and disabling initial admin password setup..."
    helm install grafana grafana/grafana \
    #   --set grafana.adminPassword="admin" \
    #   --set grafana.grafana.ini.security.disable_initial_admin_creation=true \
    #   --set-string admin.existingSecret=""


    # Expose Grafana service as NodePort
    echo "🌍 Exposing Grafana service with NodePort..."
    kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext
fi

# List services to verify installation
echo "📋 Listing the services to verify installation..."
kubectl get service | grep -E 'grafana-ext|prometheus-server-ext'
