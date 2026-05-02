# Manifestos AKS - Fase 04

Trilha nova para AKS, mantendo os manifestos antigos intactos.

Antes de aplicar, ajuste `01-secret-provider-class.yaml`:

- `userAssignedIdentityID`: output Terraform `aks_key_vault_secrets_provider_client_id`;
- `tenantId`: tenant da assinatura Azure;
- `keyvaultName`: nome real do Key Vault, se diferente do default.

Instale o ingress-nginx antes de aplicar o Ingress:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer
```

Aplicação:

```bash
kubectl apply -f k8s/manifests/aks
```
