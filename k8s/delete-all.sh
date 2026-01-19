#!/bin/bash

# Script para deletar tudo rapidamente
echo "🗑️  Deletando todos os recursos do namespace fcg-system..."
kubectl delete namespace fcg-system

echo ""
echo "Deseja deletar o cluster Kind também? (s/N)"
read -r response
if [[ "$response" =~ ^([sS][iI][mM]|[sS])$ ]]; then
  echo "🗑️  Deletando cluster Kind..."
  kind delete cluster --name fcg-cluster
  echo "✅ Cluster deletado!"
else
  echo "✓ Cluster mantido"
fi

echo ""
echo "Para fazer deploy novamente, execute: ./deploy.sh"
