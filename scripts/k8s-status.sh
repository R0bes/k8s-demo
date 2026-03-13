#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="k8s-demo"

if ! kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  echo "Kind cluster '${CLUSTER_NAME}' is not running."
  exit 0
fi

kubectl get pods -n k8s-demo
echo
kubectl get ingress -n k8s-demo