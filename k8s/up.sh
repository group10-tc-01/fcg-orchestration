#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FASE04_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
MANIFEST_DIR="$SCRIPT_DIR/manifests"

CLUSTER_NAME="${CLUSTER_NAME:-fcg-fase04-local}"
SQL_PASSWORD="${FCG_LOCAL_SQL_PASSWORD:-FcgLocal123!}"
SEQ_PASSWORD="${FCG_LOCAL_SEQ_PASSWORD:-FcgLocal123!}"
JWT_SECRET_KEY="${FCG_LOCAL_JWT_SECRET_KEY:-local-development-jwt-secret-key-for-fcg-fase04-1234567890}"

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing required command: $command_name" >&2
    exit 1
  fi
}

wait_for_rollout() {
  local namespace="$1"
  local deployment="$2"
  local timeout="${3:-300s}"

  kubectl -n "$namespace" rollout status "deployment/$deployment" --timeout="$timeout"
}

wait_for_job() {
  local namespace="$1"
  local job="$2"
  local timeout="${3:-300s}"

  if ! kubectl -n "$namespace" wait --for=condition=complete "job/$job" --timeout="$timeout"; then
    echo ""
    echo "Job $job failed or timed out. Recent logs:"
    kubectl -n "$namespace" logs "job/$job" --tail=100 || true
    exit 1
  fi
}

create_secret() {
  local namespace="$1"
  local name="$2"
  shift 2

  kubectl -n "$namespace" create secret generic "$name" "$@" --dry-run=client -o yaml | kubectl apply -f -
}

build_and_load_image() {
  local repo_dir="$1"
  local dockerfile="$2"
  local image="$3"

  echo "Building image: $image"
  docker build -t "$image" -f "$repo_dir/$dockerfile" "$repo_dir"

  echo "Loading image into Kind: $image"
  kind load docker-image "$image" --name "$CLUSTER_NAME"
}

require_command docker
require_command kind
require_command kubectl

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running or is not available from this shell." >&2
  exit 1
fi

if ! kind get clusters 2>/dev/null | grep -Fxq "$CLUSTER_NAME"; then
  echo "Creating Kind cluster: $CLUSTER_NAME"
  kind create cluster --name "$CLUSTER_NAME" --config "$SCRIPT_DIR/kind-cluster-config.yaml"
else
  echo "Kind cluster already exists: $CLUSTER_NAME"
  kubectl config use-context "kind-$CLUSTER_NAME" >/dev/null
fi

build_and_load_image "$FASE04_ROOT/fcg-users" "src/FCG.Users.WebApi/Dockerfile" "fcg-users:local"
build_and_load_image "$FASE04_ROOT/fcg-payments" "src/FCG.Payments.WebApi/Dockerfile" "fcg-payments:local"
build_and_load_image "$FASE04_ROOT/fcg-catalog" "src/FCG.Catalog.WebApi/Dockerfile" "fcg-catalog:local"

echo "Applying namespaces"
kubectl apply -f "$MANIFEST_DIR/00-namespaces.yaml"

echo "Creating local secrets"
create_secret fcg-infra sqlserver-local-secret \
  --from-literal=sa-password="$SQL_PASSWORD"

create_secret fcg-infra seq-local-secret \
  --from-literal=admin-password="$SEQ_PASSWORD"

create_secret fcg-users fcg-users-local-secret \
  --from-literal=connection-string="Server=sqlserver-service.fcg-infra.svc.cluster.local;Database=fcg_user;User Id=sa;Password=$SQL_PASSWORD;TrustServerCertificate=True;" \
  --from-literal=jwt-secret-key="$JWT_SECRET_KEY"

create_secret fcg-payments fcg-payments-local-secret \
  --from-literal=connection-string="Server=sqlserver-service.fcg-infra.svc.cluster.local;Database=fcg_payments;User Id=sa;Password=$SQL_PASSWORD;TrustServerCertificate=True;" \
  --from-literal=jwt-secret-key="$JWT_SECRET_KEY"

create_secret fcg-catalog fcg-catalog-local-secret \
  --from-literal=connection-string="Server=sqlserver-service.fcg-infra.svc.cluster.local,1433;Initial Catalog=fcg_catalog;User Id=sa;Password=$SQL_PASSWORD;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;" \
  --from-literal=jwt-secret-key="$JWT_SECRET_KEY"

echo "Applying infrastructure"
kubectl apply -f "$MANIFEST_DIR/infra/01-sqlserver.yaml"
wait_for_rollout fcg-infra sqlserver 300s

kubectl -n fcg-infra delete job sqlserver-init --ignore-not-found=true
kubectl apply -f "$MANIFEST_DIR/infra/02-sqlserver-init-job.yaml"
wait_for_job fcg-infra sqlserver-init 300s

kubectl apply \
  -f "$MANIFEST_DIR/infra/03-kafka.yaml" \
  -f "$MANIFEST_DIR/infra/04-mongodb.yaml" \
  -f "$MANIFEST_DIR/infra/05-redis.yaml" \
  -f "$MANIFEST_DIR/infra/06-elasticsearch.yaml" \
  -f "$MANIFEST_DIR/infra/07-seq.yaml" \
  -f "$MANIFEST_DIR/infra/08-kafka-ui.yaml" \
  -f "$MANIFEST_DIR/infra/09-redisinsight.yaml" \
  -f "$MANIFEST_DIR/infra/10-kibana.yaml"

wait_for_rollout fcg-infra kafka 300s
wait_for_rollout fcg-infra mongodb 300s
wait_for_rollout fcg-infra redis 180s
wait_for_rollout fcg-infra elasticsearch 300s
wait_for_rollout fcg-infra seq 180s
wait_for_rollout fcg-infra kafka-ui 180s
wait_for_rollout fcg-infra redisinsight 180s
wait_for_rollout fcg-infra kibana 300s

echo "Applying applications"
kubectl apply -f "$MANIFEST_DIR/apps/fcg-users"
kubectl apply -f "$MANIFEST_DIR/apps/fcg-payments"
kubectl apply -f "$MANIFEST_DIR/apps/fcg-catalog"

wait_for_rollout fcg-users fcg-users 300s
wait_for_rollout fcg-payments fcg-payments 300s
wait_for_rollout fcg-catalog fcg-catalog 300s

echo ""
echo "FCG fase 04 local Kubernetes is ready."
echo ""
echo "Applications:"
echo "  Users:    http://localhost:5050"
echo "  Payments: http://localhost:5054"
echo "  Catalog:  http://localhost:5000"
echo ""
echo "Tools:"
echo "  Kafka UI:      http://localhost:8081"
echo "  Seq UI:        http://localhost:5342"
echo "  RedisInsight:  http://localhost:5540"
echo "  Elasticsearch: http://localhost:9200"
echo "  Kibana:        http://localhost:5601"
echo ""
echo "Useful checks:"
echo "  kubectl get pods -n fcg-infra"
echo "  kubectl get pods -n fcg-users"
echo "  kubectl get pods -n fcg-payments"
echo "  kubectl get pods -n fcg-catalog"
