#!/usr/bin/env bash
set -euo pipefail

ARGOCD_NAMESPACE="argocd"
ARGOCD_INSTALL_MANIFEST="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
ARGOCD_APPLICATION_MANIFEST="ops/argocd/application.yaml"

echo ">>> Ensuring Argo CD namespace exists..."
kubectl create namespace "${ARGOCD_NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

echo ">>> Installing Argo CD..."
kubectl apply -n "${ARGOCD_NAMESPACE}" -f "${ARGOCD_INSTALL_MANIFEST}"

echo ">>> Waiting for Argo CD server deployment..."
kubectl rollout status deployment/argocd-server -n "${ARGOCD_NAMESPACE}" --timeout=300s

echo ">>> Applying Argo CD application..."
kubectl apply -f "${ARGOCD_APPLICATION_MANIFEST}"

echo
echo ">>> Argo CD installed."
echo ">>> To access the UI, run:"
echo "kubectl port-forward svc/argocd-server -n ${ARGOCD_NAMESPACE} 8081:443"
echo
echo ">>> Then open:"
echo "https://localhost:8081"
echo
echo ">>> To get the initial admin password, run:"
echo "argocd admin initial-password -n ${ARGOCD_NAMESPACE}"
