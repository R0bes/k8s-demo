#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="k8s-demo"
KIND_CONFIG="ops/kind/config.yaml"
INGRESS_MANIFEST="https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"

echo ">>> Checking if kind cluster '${CLUSTER_NAME}' already exists..."
if ! kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  echo ">>> Creating kind cluster..."
  kind create cluster --config "${KIND_CONFIG}"
else
  echo ">>> Kind cluster already exists."
fi

echo ">>> Installing ingress-nginx..."
kubectl apply -f "${INGRESS_MANIFEST}"

echo ">>> Waiting for ingress-nginx controller deployment to be ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=180s

echo ">>> Building backend image..."
docker build -t k8s-demo-backend ./app/backend

echo ">>> Building frontend image..."
docker build -t k8s-demo-frontend ./app/frontend

echo ">>> Loading images into kind..."
kind load docker-image k8s-demo-backend --name "${CLUSTER_NAME}"
kind load docker-image k8s-demo-frontend --name "${CLUSTER_NAME}"

echo ">>> Applying Kubernetes manifests..."
kubectl apply -f ops/k8s/namespace.yaml
kubectl apply -f ops/k8s/postgres/
kubectl apply -f ops/k8s/backend/
kubectl apply -f ops/k8s/frontend/
kubectl apply -f ops/k8s/ingress-frontend.yaml
kubectl apply -f ops/k8s/ingress-backend.yaml

echo ">>> Waiting for application deployments..."
kubectl rollout status deployment/postgres -n k8s-demo --timeout=180s
kubectl rollout status deployment/backend -n k8s-demo --timeout=180s
kubectl rollout status deployment/frontend -n k8s-demo --timeout=180s

echo
echo ">>> Cluster status"
kubectl get pods -n k8s-demo
echo
kubectl get ingress -n k8s-demo
echo
echo ">>> Application should be reachable at:"
echo "http://k8s-demo.local"