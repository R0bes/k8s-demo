#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="k8s-demo"
KIND_CONFIG="ops/kind/config.yaml"
INGRESS_MANIFEST="https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
RELEASE_NAME="k8s-demo"
NAMESPACE="k8s-demo"
CHART_PATH="ops/helm/k8s-demo"

echo ">>> Checking if kind cluster '${CLUSTER_NAME}' already exists..."
if ! kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  echo ">>> Creating kind cluster..."
  kind create cluster --config "${KIND_CONFIG}"
else
  echo ">>> Kind cluster already exists."
fi

echo ">>> Ensuring kubectl context is set..."
kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null

echo ">>> Installing ingress-nginx..."
kubectl apply -f "${INGRESS_MANIFEST}"

echo ">>> Waiting for ingress-nginx controller deployment..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=180s

echo ">>> Building backend image..."
docker build -t k8s-demo-backend ./app/backend

echo ">>> Building frontend image..."
docker build -t k8s-demo-frontend ./app/frontend

echo ">>> Loading images into kind..."
kind load docker-image k8s-demo-backend --name "${CLUSTER_NAME}"
kind load docker-image k8s-demo-frontend --name "${CLUSTER_NAME}"

echo ">>> Installing or upgrading Helm release..."
helm upgrade --install "${RELEASE_NAME}" "${CHART_PATH}" --namespace "${NAMESPACE}" --create-namespace

echo ">>> Waiting for application deployments..."
kubectl rollout status deployment/postgres -n "${NAMESPACE}" --timeout=180s
kubectl rollout status deployment/backend -n "${NAMESPACE}" --timeout=180s
kubectl rollout status deployment/frontend -n "${NAMESPACE}" --timeout=180s

echo
echo ">>> Helm release status"
helm list -n "${NAMESPACE}"
echo
kubectl get pods -n "${NAMESPACE}"
echo
kubectl get ingress -n "${NAMESPACE}"
echo
echo ">>> Application should be reachable at:"
echo "http://k8s-demo.local"