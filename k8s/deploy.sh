#!/bin/bash

# Script de deploy completo - aplica tudo na ordem correta
echo "🚀 Iniciando deploy do FCG Kubernetes..."

# Verifica se o cluster Kind existe
if ! kind get clusters 2>/dev/null | grep -q "fcg-cluster"; then
  echo "📦 Criando cluster Kind..."
  kind create cluster --config kind-cluster-config.yaml
  echo "✅ Cluster criado!"
else
  echo "✓ Cluster Kind já existe"
fi

# Apply in order (namespace, secrets, configs, infrastructure)
kubectl apply -f 00-namespace.yaml \
  -f 01-secrets.yaml \
  -f 02-configmaps.yaml \
  -f 03-sqlserver-deployment.yaml \
  -f 05-sqlserver-service.yaml \
  -f 04-kafka-deployment.yaml \
  -f 06-kafka-service.yaml

echo "⏳ Aguardando SQL Server ficar pronto..."
kubectl wait --for=condition=ready pod -l app=sqlserver -n fcg-system --timeout=120s

echo "🗄️  Inicializando bancos de dados..."
kubectl apply -f 07-sqlserver-init-job.yaml
kubectl wait --for=condition=complete job/sqlserver-init -n fcg-system --timeout=120s

echo "⏳ Aguardando Kafka ficar pronto..."
kubectl wait --for=condition=ready pod -l app=kafka -n fcg-system --timeout=120s

# Deploy de todos os microserviços
echo "🎯 Fazendo deploy dos microserviços..."
kubectl apply -f 07-microservices/

echo ""
echo "✅ Deploy concluído!"
echo ""
echo "📊 Verificar status:"
echo "  kubectl get pods -n fcg-system -w"
