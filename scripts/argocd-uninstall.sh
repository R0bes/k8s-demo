#!/usr/bin/env bash
set -euo pipefail

ARGOCD_NAMESPACE="argocd"

if kubectl get namespace "${ARGOCD_NAMESPACE}" >/dev/null 2>&1; then
  echo ">>> Deleting Argo CD namespace..."
  kubectl delete namespace "${ARGOCD_NAMESPACE}"
else
  echo ">>> Namespace '${ARGOCD_NAMESPACE}' does not exist."
fi

echo ">>> Done."