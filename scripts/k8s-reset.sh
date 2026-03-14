#!/usr/bin/env bash
set -euo pipefail

./scripts/k8s-down.sh
./scripts/k8s-up.sh
