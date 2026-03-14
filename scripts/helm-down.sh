#!/usr/bin/env bash
set -euo pipefail

RELEASE_NAME="k8s-demo"
NAMESPACE="k8s-demo"

if ! kubectl get namespace "${NAMESPACE}" >/dev/null 2>&1; then
  echo ">>> Namespace '${NAMESPACE}' does not exist. Nothing to uninstall."
  exit 0
fi

if helm status "${RELEASE_NAME}" -n "${NAMESPACE}" >/dev/null 2>&1; then
  echo ">>> Uninstalling Helm release '${RELEASE_NAME}'..."
  helm uninstall "${RELEASE_NAME}" -n "${NAMESPACE}"
else
  echo ">>> Helm release '${RELEASE_NAME}' is not installed."
fi

echo ">>> Done."