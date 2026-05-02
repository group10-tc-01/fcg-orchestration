#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-fcg-fase04-local}"
DELETE_CLUSTER="false"

for arg in "$@"; do
  case "$arg" in
    --cluster)
      DELETE_CLUSTER="true"
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: bash down.sh [--cluster]" >&2
      exit 1
      ;;
  esac
done

if [ "$DELETE_CLUSTER" = "true" ]; then
  echo "Deleting Kind cluster: $CLUSTER_NAME"
  kind delete cluster --name "$CLUSTER_NAME"
  exit 0
fi

echo "Deleting local FCG namespaces"
kubectl delete namespace fcg-catalog --ignore-not-found=true
kubectl delete namespace fcg-payments --ignore-not-found=true
kubectl delete namespace fcg-users --ignore-not-found=true
kubectl delete namespace fcg-infra --ignore-not-found=true

echo ""
echo "Namespaces removed. The Kind cluster was kept."
echo "To delete the cluster too, run: bash down.sh --cluster"
