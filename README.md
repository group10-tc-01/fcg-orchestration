# FCG Orchestration - Fase 04

Repositório de orquestração e infraestrutura da FIAP Cloud Games para a Fase 04 do Tech Challenge.

Esta versão foi ajustada para uma entrega cloud-native com foco em menor custo possível na Azure, mantendo os componentes exigidos para a fase:

- Azure Kubernetes Service (AKS) no tier Free;
- Azure Container Registry (ACR) Basic;
- Azure SQL Database Basic;
- Azure Key Vault para segredos;
- API Management em Developer;
- Azure Functions em Consumption;
- Event Hub para eventos consumidos pelas Functions;
- Azure Communication Services para envio de e-mail;
- Redis, MongoDB e Elasticsearch como workloads dentro do AKS.

> A pasta `docker` foi removida. A execução alvo da Fase 04 é AKS + Terraform + manifestos Kubernetes.

---

## Índice

- [Arquitetura da Fase 04](#arquitetura-da-fase-04)
- [O Que Este Repositório Provisiona](#o-que-este-repositório-provisiona)
- [Estrutura](#estrutura)
- [Pré-requisitos](#pré-requisitos)
- [Provisionamento com Terraform](#provisionamento-com-terraform)
- [Deploy no AKS](#deploy-no-aks)
- [Segredos](#segredos)
- [Tiers de Baixo Custo](#tiers-de-baixo-custo)
- [Validação](#validação)
- [Observações Importantes](#observações-importantes)

---

## Arquitetura da Fase 04

```text
Internet
  -> API Management (Developer)
    -> Ingress NGINX / Load Balancer
      -> AKS Free tier
        -> UsersAPI
        -> CatalogAPI
        -> PaymentsAPI
        -> Redis
        -> MongoDB
        -> Elasticsearch

Azure gerenciado:
  -> ACR Basic
  -> Azure SQL Database Basic
  -> Azure Key Vault
  -> Event Hub Standard
  -> Azure Functions Consumption
  -> Azure Communication Services
```

O AKS executa os microserviços e as dependências de performance exigidas pela fase. Os serviços gerenciados da Azure ficam apenas onde são necessários para atender o enunciado e os fluxos existentes: SQL, registry, segredos, APIM, eventos e Functions.

---

## O Que Este Repositório Provisiona

### Terraform

O Terraform em `terraform/` provisiona:

| Módulo | Recurso | Motivo |
|---|---|---|
| `resource_group` | Resource Group | Agrupamento dos recursos |
| `acr` | Azure Container Registry | Registry privado obrigatório |
| `aks` | Azure Kubernetes Service | Kubernetes gerenciado obrigatório |
| `database` | Azure SQL Server + databases | Persistência transacional |
| `keyvault` | Azure Key Vault + secrets | Zero credenciais hardcoded |
| `eventhub` | Event Hub Namespace + hubs | Eventos para APIs e Functions |
| `functions` | Azure Function App | Processamento assíncrono |
| `communication_service` | Azure Communication Services | Envio de e-mail pelas Functions |
| `apim` | API Management | Gateway externo da solução |

O módulo antigo de Web Apps foi removido. Os microserviços não são mais hospedados em Azure Web Apps; eles rodam no AKS.

### Kubernetes

A trilha nova da Fase 04 fica em:

```text
k8s/manifests/aks/
```

Ela contém:

- namespace `fcg-system`;
- `SecretProviderClass` para Azure Key Vault CSI Driver;
- Redis;
- MongoDB;
- Elasticsearch;
- deployments e services dos microserviços;
- Ingress para exposição HTTP.

Os manifestos antigos em `k8s/` ainda existem como legado/local, mas a trilha recomendada para a Fase 04 é `k8s/manifests/aks/`.

---

## Estrutura

```text
.
├── README.md
├── k8s/
│   ├── manifests/
│   │   └── aks/                 # Manifestos oficiais da Fase 04 em AKS
│   └── ...                      # Manifestos legados locais
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── output.tf
    ├── terraform.tfvars.example
    └── modules/
        ├── acr/
        ├── aks/
        ├── apim/
        ├── communication_service/
        ├── database/
        ├── eventhub/
        ├── functions/
        ├── keyvault/
        └── resource_group/
```

---

## Pré-requisitos

- Terraform 1.6+;
- Azure CLI autenticado;
- permissões para criar AKS, ACR, SQL Database, Key Vault, APIM, Event Hub, Functions e Communication Services;
- `kubectl`;
- Helm, para instalar o ingress-nginx;
- imagens Docker dos serviços publicadas no ACR.

---

## Provisionamento com Terraform

Entre na pasta Terraform:

```bash
cd terraform
terraform init
```

Crie seu `terraform.tfvars` a partir do exemplo:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Preencha ao menos:

```hcl
sql_admin_password = "SUA_SENHA_FORTE"
jwt_secret_key     = "SUA_CHAVE_JWT_FORTE"
```

Se o endereço público do Ingress já existir, ajuste:

```hcl
apim_backend_base_url = "https://SEU_INGRESS_PUBLICO"
```

Valide e planeje:

```bash
terraform fmt -recursive
terraform validate
terraform plan
```

Aplique:

```bash
terraform apply
```

Outputs úteis:

```bash
terraform output aks_name
terraform output acr_login_server
terraform output key_vault_name
terraform output aks_key_vault_secrets_provider_client_id
terraform output apim_gateway_url
```

---

## Deploy no AKS

Autentique no cluster:

```bash
az aks get-credentials \
  --resource-group <resource-group> \
  --name <aks-name>
```

Instale o ingress-nginx:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer
```

Antes de aplicar os manifestos, ajuste em `k8s/manifests/aks/01-secret-provider-class.yaml`:

- `userAssignedIdentityID`: output `aks_key_vault_secrets_provider_client_id`;
- `tenantId`: tenant da assinatura Azure;
- `keyvaultName`: nome real do Key Vault, se diferente do padrão.

Depois aplique:

```bash
kubectl apply -f k8s/manifests/aks
```

Verifique:

```bash
kubectl get pods -n fcg-system
kubectl get svc -n fcg-system
kubectl get ingress -n fcg-system
```

---

## Segredos

Credenciais reais não devem ser versionadas.

O Terraform grava no Key Vault os segredos necessários para runtime:

- `sql-connection-catalog`;
- `sql-connection-users`;
- `sql-connection-payments`;
- `jwt-secret-key`;
- `redis-connection`;
- `mongodb-connection`;
- `elasticsearch-uri`;
- `eventhub-connection`;
- `communication-connection`.

Os pods no AKS acessam esses valores via Secrets Store CSI Driver e `SecretProviderClass`.

---

## Tiers de Baixo Custo

Defaults atuais:

| Recurso | Tier/SKU |
|---|---|
| AKS | Free |
| AKS node pool | 1 nó `Standard_B2ms` |
| ACR | Basic |
| Azure SQL Database | Basic |
| Azure Functions | Consumption (`Y1`) |
| Storage Account das Functions | Standard LRS |
| Event Hub | Standard, 1 throughput unit |
| APIM | Developer_1 |
| Key Vault | Standard |

APIM Developer não é o menor custo absoluto, mas foi mantido porque faz parte da decisão da entrega.

---

## Validação

Validação Terraform:

```bash
cd terraform
terraform fmt -recursive
terraform validate
```

Validação Kubernetes, se `kubectl` estiver instalado:

```bash
kubectl apply --dry-run=client --validate=false -f k8s/manifests/aks
```

Verificações úteis:

```bash
kubectl rollout status deployment/fcg-users -n fcg-system
kubectl rollout status deployment/fcg-catalog -n fcg-system
kubectl rollout status deployment/fcg-payments -n fcg-system
```

---

## Observações Importantes

- A pasta `docker` não faz mais parte desta entrega.
- O módulo Terraform de Web Apps foi removido.
- A trilha oficial da Fase 04 é AKS, não Azure Web Apps.
- SQL Server e Event Hub são serviços gerenciados na Azure, não workloads dentro do cluster.
- Redis, MongoDB e Elasticsearch rodam dentro do AKS para reduzir custo.
- Para economizar, suba a infraestrutura apenas durante testes, gravação do vídeo e validação final.
